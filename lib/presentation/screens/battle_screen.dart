import 'dart:async';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart' show kDebugMode;
import 'package:flutter/material.dart';
import '../../data/models/scenario_data.dart';
import '../../data/models/difficulty_mode.dart';
import '../../data/repositories/scenario_repository.dart';
import '../../domain/scoring/battle_event_log.dart';
import '../../domain/state/battle_state.dart';
import '../../core/services/audio_manager.dart';
import '../../flame/battle_game.dart';
import '../widgets/help_modal.dart';
import 'result_screen.dart';

class BattleScreen extends StatefulWidget {
  final Scenario scenario;
  final String? alternativePerspectiveId;
  final DifficultyMode difficultyMode;

  const BattleScreen({
    super.key,
    required this.scenario,
    this.alternativePerspectiveId,
    this.difficultyMode = DifficultyMode.normal,
  });

  @override
  State<BattleScreen> createState() => _BattleScreenState();
}

class _BattleScreenState extends State<BattleScreen> {
  // デバッグパネルはデバッグビルドのみ表示する（本番で内部数値が
  // 常時表示されてしまっていたのを修正）。
  static const bool _debugMode = kDebugMode;

  BattleGame? _battleGame;
  ScenarioData? _scenarioData;
  Timer? _uiTimer;
  bool _loading = true;
  String? _errorMessage;
  TurningPoint? _lastTP;

  // Cached UI values
  double _playerRatio = 1.0;
  double _enemyRatio = 1.0;
  double _elapsed = 0;
  int _tpCount = 0;
  int _commandCount = 0;
  int _commandScore = 0;
  int _playerUnitCount = 0;
  int _enemyUnitCount = 0;
  int _comboCount = 0;
  double _comboMultiplier = 1.0;
  double _battleMomentum = 0.5;
  late final List<String> _commandHistory;

  @override
  void initState() {
    super.initState();
    _commandHistory = [];
    _loadScenario();
  }

  Future<void> _loadScenario() async {
    try {
      var data = await ScenarioRepository().getScenario(widget.scenario);

      // Apply alternative perspective if specified
      if (widget.alternativePerspectiveId != null &&
          data.alternativePerspective != null) {
        final altPerspective = data.alternativePerspective!;
        data = ScenarioData(
          id: data.id,
          displayName: altPerspective.displayName,
          year: data.year,
          description: altPerspective.description,
          playerInitialStrength:
              altPerspective.playerUnits.fold(0, (sum, u) => sum + u.strength),
          enemyInitialStrength:
              altPerspective.enemyUnits.fold(0, (sum, u) => sum + u.strength),
          difficulty: altPerspective.difficulty,
          estimatedDuration: data.estimatedDuration,
          backgroundImage: data.backgroundImage,
          turningPoints: altPerspective.turningPoints,
          playerUnits: altPerspective.playerUnits,
          enemyUnits: altPerspective.enemyUnits,
          alternativePerspective: data.alternativePerspective,
        );
      }

      // Apply difficulty multipliers
      data = _applyDifficultyMultipliers(data, widget.difficultyMode);

      final game = BattleGame(scenarioData: data);
      game.onBattleEnd = _onBattleEnd;
      game.onTurningPointAchieved = (tp, idx) {
        if (!mounted) return;
        setState(() => _lastTP = tp);
        Future.delayed(const Duration(seconds: 2), () {
          if (mounted) setState(() => _lastTP = null);
        });
      };

      if (!mounted) return;
      setState(() {
        _scenarioData = data;
        _battleGame = game;
        _playerUnitCount = data.playerUnits.length;
        _enemyUnitCount = data.enemyUnits.length;
        _loading = false;
      });

      _uiTimer = Timer.periodic(const Duration(milliseconds: 100), (_) {
        if (!mounted) return;
        final g = _battleGame;
        if (g == null || !g.isLoaded) return;
        setState(() {
          _playerRatio = g.playerStrengthRatio;
          _enemyRatio = g.enemyStrengthRatio;
          _elapsed = g.elapsedTime;
          _tpCount = g.tpAchievedCount;
          _commandCount = g.commandCount;
          _commandScore = g.commandScore;
          _comboCount = g.currentCombo;
          _comboMultiplier = g.comboMultiplier;
          _battleMomentum = g.battleMomentum;
        });
      });
    } catch (e) {
      if (mounted) {
        setState(() {
          _errorMessage = 'シナリオの読み込みに失敗しました: $e';
          _loading = false;
        });
      }
    }
  }

  /// 難易度に基づいてユニット兵力を調整
  ScenarioData _applyDifficultyMultipliers(
    ScenarioData data,
    DifficultyMode mode,
  ) {
    if (mode == DifficultyMode.normal) {
      return data; // ノーマルは調整なし
    }

    // プレイヤーユニットの兵力を調整
    final adjustedPlayerUnits = data.playerUnits.map((unit) {
      return UnitDataSnapshot(
        id: unit.id,
        name: unit.name,
        type: unit.type,
        strength: (unit.strength * mode.unitStrengthMultiplier).toInt(),
      );
    }).toList();

    // 敵ユニットの兵力を調整
    final adjustedEnemyUnits = data.enemyUnits.map((unit) {
      return UnitDataSnapshot(
        id: unit.id,
        name: unit.name,
        type: unit.type,
        strength: (unit.strength * mode.enemyUnitStrengthMultiplier).toInt(),
      );
    }).toList();

    // 調整されたユニットから初期兵力を再計算
    final playerInitialStrength =
        adjustedPlayerUnits.fold(0, (sum, u) => sum + u.strength);
    final enemyInitialStrength =
        adjustedEnemyUnits.fold(0, (sum, u) => sum + u.strength);

    return ScenarioData(
      id: data.id,
      displayName: data.displayName,
      year: data.year,
      description: data.description,
      playerInitialStrength: playerInitialStrength,
      enemyInitialStrength: enemyInitialStrength,
      difficulty: data.difficulty,
      estimatedDuration: data.estimatedDuration,
      backgroundImage: data.backgroundImage,
      turningPoints: data.turningPoints,
      playerUnits: adjustedPlayerUnits,
      enemyUnits: adjustedEnemyUnits,
      alternativePerspective: data.alternativePerspective,
    );
  }

  void _onBattleEnd(BattleStateData data) {
    _uiTimer?.cancel();
    if (!mounted) return;
    Navigator.pushReplacementNamed(
      context,
      '/result',
      arguments: ResultScreenArgs(
        scenario: widget.scenario,
        data: data,
      ),
    );
  }

  @override
  void dispose() {
    _uiTimer?.cancel();
    // 戦闘BGMを止める（結果・メッセージ・ホーム画面まで鳴り続けるのを防ぐ）。
    AudioManager().stopBgm();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    if (_errorMessage != null) {
      return Scaffold(
        body: Center(
          child: Text(_errorMessage!, style: const TextStyle(color: Colors.red)),
        ),
      );
    }

    final game = _battleGame!;
    final data = _scenarioData!;

    return Scaffold(
      backgroundColor: const Color(0xFF0A1A0A),
      body: SafeArea(
        child: Column(
          children: [
            _BattleStatusBar(
              displayName: data.displayName,
              playerRatio: _playerRatio,
              enemyRatio: _enemyRatio,
              elapsed: _elapsed,
              battleMomentum: _battleMomentum,
              context: context,
              difficultyMode: widget.difficultyMode,
            ),
            Expanded(
              child: Stack(
                children: [
                  GameWidget(game: game),
                  if (_lastTP != null) _TurningPointBanner(tp: _lastTP!),
                  if (_debugMode)
                    _DebugPanel(
                      elapsed: _elapsed,
                      playerCount: _playerUnitCount,
                      enemyCount: _enemyUnitCount,
                      playerRatio: _playerRatio,
                      enemyRatio: _enemyRatio,
                      tpCount: _tpCount,
                      tpTotal: data.turningPoints.length,
                      commandCount: _commandCount,
                      commandHistory: _commandHistory,
                    ),
                ],
              ),
            ),
            _BattleCommandUI(
              tpCount: _tpCount,
              tpTotal: data.turningPoints.length,
              commandScore: _commandScore,
              comboCount: _comboCount,
              comboMultiplier: _comboMultiplier,
              onCommand: (cmd) {
                game.executeCommand(cmd);
                if (_debugMode) {
                  setState(() {
                    _commandHistory.add(cmd.name);
                    if (_commandHistory.length > 10) {
                      _commandHistory.removeAt(0);
                    }
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}

class _BattleStatusBar extends StatelessWidget {
  final String displayName;
  final double playerRatio;
  final double enemyRatio;
  final double elapsed;
  final double battleMomentum;
  final BuildContext context;
  final DifficultyMode difficultyMode;

  const _BattleStatusBar({
    required this.displayName,
    required this.playerRatio,
    required this.enemyRatio,
    required this.elapsed,
    required this.battleMomentum,
    required this.context,
    required this.difficultyMode,
  });

  String _formatTime(double seconds) {
    final remaining = (BattleState.maxBattleTime - seconds).clamp(0, BattleState.maxBattleTime);
    final mins = (remaining / 60).floor();
    final secs = (remaining % 60).floor();
    return '${mins.toString().padLeft(2, '0')}:${secs.toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    final remaining = BattleState.maxBattleTime - elapsed;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF2A1A0A).withValues(alpha: 0.9),
            const Color(0xFF1A0A0A).withValues(alpha: 0.95),
          ],
        ),
        border: Border(
          bottom: BorderSide(
            color: const Color(0xFFFFD700).withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: const Color(0xFFFFD700).withValues(alpha: 0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  displayName,
                  style: const TextStyle(
                    color: Color(0xFFFFD700),
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                    letterSpacing: 1.5,
                    shadows: [
                      Shadow(
                        color: Color(0xFFFFD700),
                        blurRadius: 8,
                        offset: Offset(0, 0),
                      ),
                    ],
                  ),
                ),
              ),
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: remaining < 60
                          ? Colors.red.withValues(alpha: 0.2)
                          : Colors.orange.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: remaining < 60 ? Colors.red : Colors.orange,
                        width: 1,
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.timer,
                          size: 16,
                          color: remaining < 60 ? Colors.red : Colors.orange,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          _formatTime(elapsed),
                          style: TextStyle(
                            color: remaining < 60 ? Colors.red : Colors.white,
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            letterSpacing: 0.5,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  IconButton(
                    onPressed: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => HelpModal(
                          initialTab: 'tactics',
                          difficultyMode: difficultyMode.name,
                        ),
                      );
                    },
                    icon: const Icon(Icons.help_outline, color: Color(0xFFFFD700), size: 20),
                    constraints: const BoxConstraints(),
                    padding: EdgeInsets.zero,
                    visualDensity: VisualDensity.compact,
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.red.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.red, width: 1),
                ),
                child: const Text(
                  '味方',
                  style: TextStyle(color: Colors.red, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: _StrengthBar(value: playerRatio, color: Colors.red),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _StrengthBar(
                  value: enemyRatio,
                  color: Colors.blue,
                  reversed: true,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(color: Colors.blue, width: 1),
                ),
                child: const Text(
                  '敵',
                  style: TextStyle(color: Colors.blue, fontSize: 11, fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          // 戦闘勢い表示
          _BattleMomentumBar(momentum: battleMomentum),
        ],
      ),
    );
  }
}

class _StrengthBar extends StatelessWidget {
  final double value;
  final Color color;
  final bool reversed;

  const _StrengthBar({
    required this.value,
    required this.color,
    this.reversed = false,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final filled = constraints.maxWidth * value.clamp(0.0, 1.0);
      return Container(
        height: 12,
        decoration: BoxDecoration(
          color: const Color(0xFF1A1A1A),
          borderRadius: BorderRadius.circular(6),
          border: Border.all(
            color: color.withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: Align(
          alignment: reversed ? Alignment.centerRight : Alignment.centerLeft,
          child: Container(
            width: filled,
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [
                  color.withValues(alpha: 0.8),
                  color,
                ],
              ),
              borderRadius: BorderRadius.circular(5),
              boxShadow: [
                BoxShadow(
                  color: color,
                  blurRadius: 8,
                  offset: const Offset(0, 0),
                ),
              ],
            ),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                gradient: LinearGradient(
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                  colors: [
                    color.withValues(alpha: 0.4),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
          ),
        ),
      );
    });
  }
}

class _BattleCommandUI extends StatelessWidget {
  final int tpCount;
  final int tpTotal;
  final int commandScore;
  final int comboCount;
  final double comboMultiplier;
  final void Function(PlayerCommand) onCommand;

  const _BattleCommandUI({
    required this.tpCount,
    required this.tpTotal,
    required this.commandScore,
    required this.comboCount,
    required this.comboMultiplier,
    required this.onCommand,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF1A0A0A).withValues(alpha: 0.95),
            const Color(0xFF0A0000).withValues(alpha: 0.98),
          ],
        ),
        border: Border(
          top: BorderSide(
            color: const Color(0xFFFFD700).withValues(alpha: 0.4),
            width: 2,
          ),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.5),
            blurRadius: 8,
            offset: const Offset(0, -2),
          ),
        ],
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: const Color(0xFF2A1A0A).withValues(alpha: 0.6),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: const Color(0xFFFFD700).withValues(alpha: 0.2),
                width: 1,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Row(
                  children: [
                    const Icon(Icons.stars, size: 16, color: Color(0xFFFFD700)),
                    const SizedBox(width: 6),
                    Text(
                      'TP: $tpCount / $tpTotal',
                      style: const TextStyle(
                        color: Color(0xFFFFD700),
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                // コンボ表示（2以上のみ表示）
                if (comboCount > 1)
                  Row(
                    children: [
                      const Icon(Icons.flash_on, size: 16, color: Color(0xFFFFAA00)),
                      const SizedBox(width: 4),
                      Text(
                        'コンボ: $comboCount',
                        style: const TextStyle(
                          color: Color(0xFFFFAA00),
                          fontSize: 13,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'x${comboMultiplier.toStringAsFixed(1)}',
                        style: const TextStyle(
                          color: Color(0xFFFF6644),
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                Row(
                  children: [
                    const Icon(Icons.trending_up, size: 16, color: Colors.orange),
                    const SizedBox(width: 6),
                    Text(
                      '采配: $commandScore',
                      style: const TextStyle(
                        color: Colors.orange,
                        fontSize: 13,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 8),
          // 1行目：基本コマンド
          Row(
            children: [
              _CommandButton(
                label: '進軍',
                icon: Icons.arrow_upward,
                color: Colors.red,
                onTap: () => onCommand(PlayerCommand.advance),
              ),
              const SizedBox(width: 6),
              _CommandButton(
                label: '撤退',
                icon: Icons.arrow_downward,
                color: Colors.blue,
                onTap: () => onCommand(PlayerCommand.retreat),
              ),
              const SizedBox(width: 6),
              _CommandButton(
                label: '待機',
                icon: Icons.pause,
                color: Colors.grey,
                onTap: () => onCommand(PlayerCommand.wait),
              ),
              const SizedBox(width: 6),
              _CommandButton(
                label: '奇襲',
                icon: Icons.bolt,
                color: Colors.orange,
                onTap: () => onCommand(PlayerCommand.ambush),
              ),
            ],
          ),
          const SizedBox(height: 6),
          // 2行目：戦術コマンド
          Row(
            children: [
              _CommandButton(
                label: '突撃',
                icon: Icons.double_arrow,
                color: const Color(0xFFFF4444),
                onTap: () => onCommand(PlayerCommand.charge),
                isSpecial: true,
              ),
              const SizedBox(width: 6),
              _CommandButton(
                label: '激励',
                icon: Icons.local_fire_department,
                color: const Color(0xFFFFAA00),
                onTap: () => onCommand(PlayerCommand.rally),
                isSpecial: true,
              ),
              const SizedBox(width: 6),
              _CommandButton(
                label: '盾陣',
                icon: Icons.shield,
                color: const Color(0xFF44AAFF),
                onTap: () => onCommand(PlayerCommand.shield),
                isSpecial: true,
              ),
              const SizedBox(width: 6),
              _CommandButton(
                label: '陣形',
                icon: Icons.grid_view,
                color: const Color(0xFF88BB44),
                onTap: () => onCommand(PlayerCommand.formation),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _CommandButton extends StatelessWidget {
  final String label;
  final IconData icon;
  final Color color;
  final VoidCallback onTap;
  final bool isSpecial;

  const _CommandButton({
    required this.label,
    required this.icon,
    required this.color,
    required this.onTap,
    this.isSpecial = false,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: EdgeInsets.symmetric(vertical: isSpecial ? 10 : 12),
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: isSpecial
                  ? [color.withValues(alpha: 0.45), color.withValues(alpha: 0.15)]
                  : [color.withValues(alpha: 0.3), color.withValues(alpha: 0.1)],
            ),
            border: Border.all(
              color: color,
              width: isSpecial ? 2.5 : 2,
            ),
            borderRadius: BorderRadius.circular(10),
            boxShadow: [
              BoxShadow(
                color: color.withValues(alpha: isSpecial ? 0.7 : 0.5),
                blurRadius: isSpecial ? 16 : 12,
                offset: const Offset(0, 0),
              ),
              BoxShadow(
                color: color.withValues(alpha: 0.2),
                blurRadius: 4,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: isSpecial ? 22 : 24, shadows: [
                Shadow(color: color, blurRadius: isSpecial ? 12 : 8, offset: Offset.zero),
              ]),
              const SizedBox(height: 3),
              Text(
                label,
                style: TextStyle(
                  color: color,
                  fontSize: isSpecial ? 12 : 13,
                  fontWeight: FontWeight.bold,
                  letterSpacing: 0.5,
                ),
              ),
              if (isSpecial)
                Text(
                  '特殊',
                  style: TextStyle(
                    color: color.withValues(alpha: 0.6),
                    fontSize: 9,
                    letterSpacing: 0.3,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _DebugPanel extends StatelessWidget {
  final double elapsed;
  final int playerCount;
  final int enemyCount;
  final double playerRatio;
  final double enemyRatio;
  final int tpCount;
  final int tpTotal;
  final int commandCount;
  final List<String> commandHistory;

  const _DebugPanel({
    required this.elapsed,
    required this.playerCount,
    required this.enemyCount,
    required this.playerRatio,
    required this.enemyRatio,
    required this.tpCount,
    required this.tpTotal,
    required this.commandCount,
    required this.commandHistory,
  });

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 8,
      right: 8,
      child: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          color: Colors.black87,
          border: Border.all(color: Colors.lime, width: 1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: DefaultTextStyle(
          style: const TextStyle(
            color: Colors.lime,
            fontSize: 10,
            fontFamily: 'monospace',
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              Text('⏱ ${elapsed.toStringAsFixed(1)}s'),
              Text('👥 P:$playerCount E:$enemyCount'),
              Text('💪 P:${(playerRatio * 100).toStringAsFixed(0)}% E:${(enemyRatio * 100).toStringAsFixed(0)}%'),
              Text('⭐ TP:$tpCount/$tpTotal'),
              Text('📋 CMD:$commandCount'),
              const SizedBox(height: 4),
              if (commandHistory.isNotEmpty)
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('--- Commands ---'),
                    ...commandHistory.skip(commandHistory.length > 5 ? commandHistory.length - 5 : 0).map(
                      (cmd) => Text('  $cmd'),
                    ),
                  ],
                ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TurningPointBanner extends StatelessWidget {
  final TurningPoint tp;

  const _TurningPointBanner({required this.tp});

  @override
  Widget build(BuildContext context) {
    return Positioned(
      top: 8,
      left: 16,
      right: 16,
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        decoration: BoxDecoration(
          color: const Color(0xFFFFD700).withValues(alpha: 0.9),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          children: [
            const Icon(Icons.stars, color: Colors.black),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'ターニングポイント達成！',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  Text(
                    '${tp.name}  +${tp.rewardPoints}点',
                    style: const TextStyle(color: Colors.black87, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _BattleMomentumBar extends StatelessWidget {
  final double momentum; // 0.0 = 敵優勢, 0.5 = イーブン, 1.0 = プレイヤー優勢

  const _BattleMomentumBar({required this.momentum});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              '敵優勢',
              style: TextStyle(color: Colors.grey, fontSize: 10),
            ),
            const SizedBox(width: 8),
            Expanded(
              child: LayoutBuilder(builder: (context, constraints) {
                final width = constraints.maxWidth;
                final playerWidth = width * momentum;

                return Container(
                  height: 6,
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A1A1A),
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(
                      color: Colors.grey.withValues(alpha: 0.3),
                      width: 0.5,
                    ),
                  ),
                  child: Stack(
                    children: [
                      // 敵側（左）
                      Align(
                        alignment: Alignment.centerLeft,
                        child: Container(
                          width: width * (1 - momentum),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.blue.withValues(alpha: 0.6),
                                Colors.blue.withValues(alpha: 0.3),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                      // プレイヤー側（右）
                      Align(
                        alignment: Alignment.centerRight,
                        child: Container(
                          width: playerWidth,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              colors: [
                                Colors.red.withValues(alpha: 0.3),
                                Colors.red.withValues(alpha: 0.6),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(3),
                          ),
                        ),
                      ),
                      // 中央インジケーター
                      Positioned(
                        left: width * 0.5 - 1,
                        top: -1,
                        bottom: -1,
                        child: Container(
                          width: 2,
                          color: Colors.yellow.withValues(alpha: 0.5),
                        ),
                      ),
                    ],
                  ),
                );
              }),
            ),
            const SizedBox(width: 8),
            const Text(
              '味方優勢',
              style: TextStyle(color: Colors.grey, fontSize: 10),
            ),
          ],
        ),
      ],
    );
  }
}
