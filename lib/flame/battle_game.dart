import 'package:flame/game.dart';
import 'package:flame/components.dart';
import '../core/services/audio_manager.dart';
import '../data/models/scenario_data.dart';
import '../domain/scoring/battle_event_log.dart';
import '../domain/scoring/score_calculator.dart';
import '../domain/state/battle_state.dart';
import 'components/effect_component.dart';
import 'components/map_background.dart';
import 'components/unit_component.dart';

class BattleGame extends FlameGame {
  final ScenarioData scenarioData;
  final double playerStrengthMultiplier;

  Function(BattleStateData)? onBattleEnd;
  Function(TurningPoint, int)? onTurningPointAchieved;

  late final BattleState _battleState;
  final _ScaledWorld _world = _ScaledWorld();
  bool _ready = false;

  BattleGame({required this.scenarioData, this.playerStrengthMultiplier = 1.0});

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    _world.scale = Vector2(size.x / 360, size.y / 640);
    await add(_world);

    await _world.add(MapBackground(scenario: scenarioData.id));

    _battleState = BattleState(
      scenario: scenarioData,
      playerStrengthMultiplier: playerStrengthMultiplier,
    );
    _battleState.onBattleEnd = (data) {
      pauseEngine();
      _playBattleEndSound(data.won);
      onBattleEnd?.call(data);
    };
    _battleState.onTurningPointAchieved = (tp, idx) {
      _spawnTpEffect();
      AudioManager().playSe('tp_achieve', 'assets/audio/tp_achieve.wav');
      onTurningPointAchieved?.call(tp, idx);
    };

    for (final unit in _battleState.playerArmy.units) {
      await _world.add(UnitComponent(
        unit: unit,
        isPlayer: true,
        onEffect: _spawnUnitEffect,
      ));
    }
    for (final unit in _battleState.enemyArmy.units) {
      await _world.add(UnitComponent(
        unit: unit,
        isPlayer: false,
        onEffect: _spawnUnitEffect,
      ));
    }

    _battleState.start();
    await _playBattleBgm();
    _ready = true;
  }

  void _spawnUnitEffect(Vector2 pos, UnitEffectType type, {double? damage, bool? isCritical}) {
    switch (type) {
      case UnitEffectType.hit:
        _world.add(HitFlashEffect(pos: pos, isPlayer: true));
        AudioManager().playSe('hit_${pos.hashCode % 3}', 'assets/audio/hit.wav');
      case UnitEffectType.death:
        _world.add(DeathExplosionEffect(pos: pos, isPlayer: true));
        AudioManager().playSe('death', 'assets/audio/death.wav');
      case UnitEffectType.damage:
        if (damage != null) {
          _world.add(DamageNumberEffect(
            pos: pos,
            damage: damage.toInt(),
            isCritical: isCritical ?? false,
          ));
          if (isCritical ?? false) {
            AudioManager().playSe('crit', 'assets/audio/crit.wav');
          }
        }
    }
  }

  void _spawnTpEffect() {
    // TP達成エフェクトはフィールド中央に表示
    _world.add(TpSparkleEffect(pos: Vector2(180, 320)));
  }

  @override
  void onGameResize(Vector2 size) {
    super.onGameResize(size);
    if (isMounted) {
      _world.scale = Vector2(size.x / 360, size.y / 640);
    }
  }

  @override
  void update(double dt) {
    super.update(dt);
    if (_ready) _battleState.update(dt);
  }

  void executeCommand(PlayerCommand command) {
    if (!_ready) return;
    _battleState.executeCommand(command);
    _playCommandSound(command);
    _spawnCommandFeedback(command);
  }

  void _spawnCommandFeedback(PlayerCommand command) {
    // 画面中央上部にコマンド名を表示
    final commandName = switch (command) {
      PlayerCommand.advance => '進軍',
      PlayerCommand.retreat => '撤退',
      PlayerCommand.wait => '待機',
      PlayerCommand.ambush => '奇襲',
      PlayerCommand.formation => '陣形',
      PlayerCommand.rally => '激励',
      PlayerCommand.shield => '盾陣',
      PlayerCommand.charge => '突撃',
    };

    _world.add(CommandFeedbackEffect(
      pos: Vector2(180, 100),
      commandName: commandName,
    ));
  }

  Future<void> _playBattleBgm() async {
    await AudioManager().playBgm(_getBattleBgmPath());
  }

  void _playCommandSound(PlayerCommand command) {
    final soundFile = switch (command) {
      PlayerCommand.advance => 'assets/audio/advance.wav',
      PlayerCommand.retreat => 'assets/audio/retreat.wav',
      PlayerCommand.wait => 'assets/audio/wait.wav',
      PlayerCommand.ambush => 'assets/audio/ambush.wav',
      PlayerCommand.formation => 'assets/audio/formation.wav',
      PlayerCommand.rally => 'assets/audio/rally.wav',
      PlayerCommand.shield => 'assets/audio/shield.wav',
      PlayerCommand.charge => 'assets/audio/charge.wav',
    };
    AudioManager().playSe('cmd_${command.name}', soundFile);
  }

  void _playBattleEndSound(bool won) {
    AudioManager().playSe(
      'battle_end',
      won ? 'assets/audio/victory.wav' : 'assets/audio/defeat.wav',
    );
  }

  String _getBattleBgmPath() => switch (scenarioData.id) {
        Scenario.odigahara => 'assets/audio/bgm_odigahara.wav',
        Scenario.nagashino => 'assets/audio/bgm_nagashino.wav',
        Scenario.honnoJi => 'assets/audio/bgm_honnoji.wav',
        Scenario.sekigahara => 'assets/audio/bgm_sekigahara.wav',
        Scenario.kawanakajima => 'assets/audio/bgm_kawanakajima.wav',
        Scenario.itsukushima => 'assets/audio/bgm_itsukushima.wav',
      };

  double get elapsedTime => _ready ? _battleState.elapsedTime : 0;
  double get playerStrengthRatio =>
      _ready ? _battleState.playerArmy.getStrengthRatio() : 1.0;
  double get enemyStrengthRatio =>
      _ready ? _battleState.enemyArmy.getStrengthRatio() : 1.0;
  int get tpAchievedCount =>
      _ready ? _battleState.tpEvaluator.achievedCount : 0;
  int get tpTotal => scenarioData.turningPoints.length;
  int get commandCount =>
      _ready ? _battleState.commandHandler.commandHistory.length : 0;
  // 結果画面と同じ式で采配スコアを算出する（表示のズレを防ぐ）。
  int get commandScore => _ready
      ? ScoreCalculator.commandScoreForCommands(
          _battleState.commandHandler.commandHistory)
      : 0;

  // コンボ関連のゲッター
  int get currentCombo => _ready ? _battleState.commandHandler.currentCombo : 0;
  double get comboMultiplier =>
      _ready ? _battleState.commandHandler.comboMultiplier : 1.0;

  // 戦闘勢い（0.0 = 敵優勢, 0.5 = イーブン, 1.0 = プレイヤー優勢）
  double get battleMomentum =>
      _ready ? _battleState.momentum.playerMomentum : 0.5;

  BattlePhase get phase =>
      _ready ? _battleState.phase : BattlePhase.waiting;
}

class _ScaledWorld extends PositionComponent {
  _ScaledWorld() : super(position: Vector2.zero());
}
