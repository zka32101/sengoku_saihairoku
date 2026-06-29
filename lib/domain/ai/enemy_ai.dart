import '../combat/army.dart';
import '../combat/unit.dart';

enum EnemyAIState { advancing, defending, retreating, scouting }

class EnemyAI {
  final Army enemyArmy;
  final Army playerArmy;
  final double decisionInterval;

  double _nextDecisionIn = 0;
  EnemyAIState _currentState = EnemyAIState.advancing;

  EnemyAI({
    required this.enemyArmy,
    required this.playerArmy,
    this.decisionInterval = 2.0,
  });

  EnemyAIState get currentState => _currentState;

  void update(double dt) {
    _nextDecisionIn -= dt;

    if (_nextDecisionIn <= 0) {
      _makeDecision();
      _nextDecisionIn = decisionInterval;
    }

    for (final unit in enemyArmy.aliveUnits) {
      unit.update(dt);

      // スカウト時はモラル微回復
      if (!unit.isMoving) {
        unit.morale = (unit.morale + 2 * dt).clamp(0, 100);
      }
    }
  }

  void _makeDecision() {
    final strengthRatio = enemyArmy.getStrengthRatio();
    final distToPlayer = _distanceToNearestPlayer();

    if (strengthRatio < 0.2) {
      _currentState = EnemyAIState.retreating;
      _commandRetreat();
    } else if (distToPlayer < 100) {
      _currentState = EnemyAIState.defending;
      // 接触中は自動戦闘（BattleState 側で処理）
    } else if (distToPlayer < 300) {
      _currentState = EnemyAIState.advancing;
      _commandAdvance();
    } else {
      _currentState = EnemyAIState.scouting;
      _commandScout();
    }
  }

  void _commandAdvance() {
    final (cx, cy) = playerArmy.getCenterPosition();
    for (final unit in enemyArmy.aliveUnits) {
      unit.targetX = cx;
      unit.targetY = cy;
      unit.isMoving = true;
      unit.speed = _baseSpeed(unit.type);
    }
  }

  void _commandRetreat() {
    for (final unit in enemyArmy.aliveUnits) {
      // マップ上端（敵のスタート地点）へ撤退
      unit.targetX = unit.posX;
      unit.targetY = 50;
      unit.isMoving = true;
      unit.speed = _baseSpeed(unit.type) * 1.2;
    }
  }

  void _commandScout() {
    final (cx, cy) = playerArmy.getCenterPosition();
    for (final unit in enemyArmy.aliveUnits) {
      unit.targetX = cx;
      unit.targetY = cy;
      unit.isMoving = true;
      unit.speed = _baseSpeed(unit.type) * 0.5;
    }
  }

  double _distanceToNearestPlayer() {
    double minDist = double.maxFinite;
    for (final eu in enemyArmy.aliveUnits) {
      for (final pu in playerArmy.aliveUnits) {
        final d = eu.distanceTo(pu);
        if (d < minDist) minDist = d;
      }
    }
    return minDist;
  }

  double _baseSpeed(UnitType type) {
    return switch (type) {
      UnitType.cavalry => 60.0,
      UnitType.spear => 40.0,
      UnitType.archer => 35.0,
      UnitType.musket => 30.0,
    };
  }
}
