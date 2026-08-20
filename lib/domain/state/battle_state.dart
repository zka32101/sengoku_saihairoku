import 'dart:math';
import '../../data/models/scenario_data.dart';
import '../combat/army.dart';
import '../combat/unit.dart';
import '../combat/damage_calculator.dart';
import '../ai/enemy_ai.dart';
import '../scoring/battle_event_log.dart';
import '../scoring/score_calculator.dart';
import '../scoring/turning_point_evaluator.dart';

enum BattlePhase { waiting, active, ended }

enum BattleResult { none, victory, defeat, timeout }

class PlayerCommandHandler {
  final Army playerArmy;
  final BattleEventLog eventLog;
  final Army enemyArmy;

  static const double _cooldown = 0.5;
  double _nextCommandIn = 0;
  final List<CommandRecord> commandHistory = [];

  PlayerCommandHandler({
    required this.playerArmy,
    required this.eventLog,
    required this.enemyArmy,
  });

  void update(double dt) {
    _nextCommandIn = max(0, _nextCommandIn - dt);
  }

  bool executeCommand(PlayerCommand command) {
    if (_nextCommandIn > 0) return false;

    eventLog.recordCommand(command);
    commandHistory
        .add(CommandRecord(command: command, timestamp: eventLog.commands.last.timestamp));

    final (ex, ey) = enemyArmy.getCenterPosition();

    switch (command) {
      case PlayerCommand.advance:
        for (final u in playerArmy.aliveUnits) {
          u.targetX = ex;
          u.targetY = ey;
          u.isMoving = true;
        }
      case PlayerCommand.retreat:
        for (final u in playerArmy.aliveUnits) {
          u.targetX = u.posX;
          u.targetY = 550;
          u.isMoving = true;
        }
      case PlayerCommand.wait:
        for (final u in playerArmy.aliveUnits) {
          u.isMoving = false;
        }
      case PlayerCommand.ambush:
        for (final u in playerArmy.aliveUnits) {
          u.targetX = ex + (u.posX < ex ? -80 : 80);
          u.targetY = ey;
          u.isMoving = true;
        }
      case PlayerCommand.formation:
        for (final u in playerArmy.aliveUnits) {
          u.isMoving = false;
        }
      case PlayerCommand.rally:
        // 激励：攻撃力を10秒間 1.5倍
        for (final u in playerArmy.aliveUnits) {
          u.attackBuffTimer = 10.0;
          u.morale = (u.morale + 20).clamp(0, 100);
        }
      case PlayerCommand.shield:
        // 盾陣：防御力を10秒間 1.5倍 + 停止
        for (final u in playerArmy.aliveUnits) {
          u.defenseBuffTimer = 10.0;
          u.isMoving = false;
        }
      case PlayerCommand.charge:
        // 突撃：速度バフ5秒 + 全力進軍
        for (final u in playerArmy.aliveUnits) {
          u.speedBuffTimer = 5.0;
          u.targetX = ex;
          u.targetY = ey;
          u.isMoving = true;
        }
    }

    _nextCommandIn = _cooldown;
    return true;
  }

  bool get isOnCooldown => _nextCommandIn > 0;
}

class BattleStateData {
  final bool won;
  final BattleResult result;
  final double elapsedTime;
  final double casualtyRate;
  final List<bool> tpAchievements;
  final List<CommandRecord> commands;
  final int totalScore;
  final ScoreBreakdownResult scoreBreakdown;

  BattleStateData({
    required this.won,
    required this.result,
    required this.elapsedTime,
    required this.casualtyRate,
    required this.tpAchievements,
    required this.commands,
    required this.totalScore,
    required this.scoreBreakdown,
  });
}

class BattleState {
  static const double maxBattleTime = 600.0;
  static const double combatRange = 50.0;

  final ScenarioData scenario;
  late final Army playerArmy;
  late final Army enemyArmy;
  late final EnemyAI enemyAI;
  late final PlayerCommandHandler commandHandler;
  late final TurningPointEvaluator tpEvaluator;
  final BattleEventLog eventLog = BattleEventLog();
  final ScoreCalculator _scoreCalc = ScoreCalculator();

  double elapsedTime = 0;
  BattlePhase phase = BattlePhase.waiting;
  BattleResult result = BattleResult.none;
  bool _enemyCommanderKilled = false;
  bool _inCombatThisFrame = false;

  Function(BattleStateData)? onBattleEnd;
  Function(TurningPoint, int)? onTurningPointAchieved;

  BattleState({required this.scenario}) {
    _initializeArmies();
    enemyAI = EnemyAI(enemyArmy: enemyArmy, playerArmy: playerArmy);
    commandHandler = PlayerCommandHandler(
      playerArmy: playerArmy,
      eventLog: eventLog,
      enemyArmy: enemyArmy,
    );
    tpEvaluator = TurningPointEvaluator(
      scenarioId: scenario.id,
      turningPoints: scenario.turningPoints,
      eventLog: eventLog,
    );
    tpEvaluator.onAchieved = (tp, idx) => onTurningPointAchieved?.call(tp, idx);
  }

  void _initializeArmies() {
    double px = 180, py = 480;
    final playerUnits = scenario.playerUnits.asMap().entries.map((e) {
      final data = e.value;
      final type = _parseUnitType(data.type);
      return createUnitFromType(
        data.id, data.name, type, data.strength,
        px + e.key * 60, py,
      );
    }).toList();

    double ex = 180, ey = 80;
    final enemyUnits = scenario.enemyUnits.asMap().entries.map((e) {
      final data = e.value;
      final type = _parseUnitType(data.type);
      return createUnitFromType(
        data.id, data.name, type, data.strength,
        ex + e.key * 60, ey,
      );
    }).toList();

    playerArmy = Army(commanderName: scenario.displayName, units: playerUnits);
    enemyArmy = Army(commanderName: '敵将', units: enemyUnits);
  }

  UnitType _parseUnitType(String type) => switch (type) {
        'cavalry' => UnitType.cavalry,
        'spear' => UnitType.spear,
        'archer' => UnitType.archer,
        'musket' => UnitType.musket,
        _ => UnitType.spear,
      };

  void start() {
    phase = BattlePhase.active;
  }

  void update(double dt) {
    if (phase != BattlePhase.active) return;

    elapsedTime += dt;
    eventLog.tick(dt);
    commandHandler.update(dt);
    enemyAI.update(dt);
    _updateCombat(dt);
    _evaluateTurningPoints();
    _checkBattleEnd();
  }

  void _updateCombat(double dt) {
    _inCombatThisFrame = false;
    for (final pu in playerArmy.aliveUnits) {
      for (final eu in enemyArmy.aliveUnits) {
        final dist = pu.distanceTo(eu);
        if (dist < combatRange) {
          pu.isColliding = true;
          eu.isColliding = true;
          _inCombatThisFrame = true;

          final pDmg = DamageCalculator.calculate(eu, pu);
          final eDmg = DamageCalculator.calculate(pu, eu);
          pu.takeDamage(pDmg * dt);
          eu.takeDamage(eDmg * dt);

          // 敵将討死判定（最初の敵ユニットが死亡）
          if (eu.isDead && eu == enemyArmy.units.first && !_enemyCommanderKilled) {
            _enemyCommanderKilled = true;
            eventLog.enemyCommanderKilled = true;
          }
        } else {
          pu.isColliding = false;
          eu.isColliding = false;
        }
      }
    }
  }

  void _evaluateTurningPoints() {
    tpEvaluator.evaluate(
      elapsedTime: elapsedTime,
      playerStrengthRatio: playerArmy.getStrengthRatio(),
      enemyStrengthRatio: enemyArmy.getStrengthRatio(),
      playerMorale: playerArmy.getAverageMorale(),
      enemyCommanderKilled: _enemyCommanderKilled,
      inCombat: _inCombatThisFrame,
    );
  }

  void _checkBattleEnd() {
    if (enemyArmy.isDefeated) {
      _endBattle(BattleResult.victory);
    } else if (playerArmy.isDefeated) {
      _endBattle(BattleResult.defeat);
    } else if (elapsedTime >= maxBattleTime) {
      // タイムアップ: 兵力多い方が勝利
      final r = playerArmy.getTotalStrength() >= enemyArmy.getTotalStrength()
          ? BattleResult.victory
          : BattleResult.defeat;
      _endBattle(r);
    }
  }

  void _endBattle(BattleResult r) {
    phase = BattlePhase.ended;
    result = r;

    final won = r == BattleResult.victory;
    final casualtyRate = _calculateCasualtyRate();

    final scoreInput = ScoreInput(
      won: won,
      casualtyRate: casualtyRate,
      battleDurationSeconds: elapsedTime.toInt(),
      commands: commandHandler.commandHistory,
      turningPointBonus: tpEvaluator.calculateBonusScore(),
      allTurningPointsAchieved: tpEvaluator.achievementRate == 1.0,
    );

    final breakdown = _scoreCalc.calculate(scoreInput);

    onBattleEnd?.call(BattleStateData(
      won: won,
      result: r,
      elapsedTime: elapsedTime,
      casualtyRate: casualtyRate,
      tpAchievements: List.from(tpEvaluator.achievements),
      commands: List.from(commandHandler.commandHistory),
      totalScore: breakdown.total,
      scoreBreakdown: breakdown,
    ));
  }

  double _calculateCasualtyRate() {
    final lost = playerArmy.units.fold(
        0.0, (sum, u) => sum + (u.maxStrength - u.strength));
    final total = playerArmy.units.fold(0.0, (sum, u) => sum + u.maxStrength);
    return total > 0 ? lost / total : 1.0;
  }

  bool executeCommand(PlayerCommand command) =>
      commandHandler.executeCommand(command);

  double get playerStrengthPercent =>
      playerArmy.getStrengthRatio() * 100;
  double get enemyStrengthPercent =>
      enemyArmy.getStrengthRatio() * 100;
}
