import 'package:flutter/material.dart';
import '../../data/models/battle_replay.dart';

/// リプレイプレイヤーウィジェット
class ReplayPlayer extends StatefulWidget {
  final BattleReplay replay;

  const ReplayPlayer({
    super.key,
    required this.replay,
  });

  @override
  State<ReplayPlayer> createState() => _ReplayPlayerState();
}

class _ReplayPlayerState extends State<ReplayPlayer> {
  late int _currentTurnIndex;
  late bool _isPlaying;
  late int _playbackSpeed; // 1=通常, 2=2倍速, 4=4倍速

  @override
  void initState() {
    super.initState();
    _currentTurnIndex = 0;
    _isPlaying = false;
    _playbackSpeed = 1;
  }

  void _playNext() {
    if (_currentTurnIndex < widget.replay.turnStates.length - 1) {
      setState(() => _currentTurnIndex++);
    } else {
      setState(() => _isPlaying = false);
    }
  }

  void _togglePlayPause() {
    setState(() => _isPlaying = !_isPlaying);

    if (_isPlaying) {
      _startAutoPlay();
    }
  }

  void _startAutoPlay() {
    Future.delayed(Duration(milliseconds: 1500 ~/ _playbackSpeed), () {
      if (_isPlaying && mounted) {
        _playNext();
        _startAutoPlay();
      }
    });
  }

  void _seekToTurn(int turn) {
    setState(() {
      _currentTurnIndex = turn.clamp(0, widget.replay.turnStates.length - 1);
      _isPlaying = false;
    });
  }

  ReplayTurnState get _currentState => widget.replay.turnStates[_currentTurnIndex];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // リプレイ情報
        Container(
          padding: const EdgeInsets.all(16),
          color: Colors.grey[900],
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                widget.replay.summary,
                style: const TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                widget.replay.details,
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[400],
                ),
              ),
            ],
          ),
        ),

        // 現在のターン状態表示
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'ターン ${_currentState.turnNumber}',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  if (_currentState.commandUsed != null)
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 6,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.blue[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        'コマンド: ${_currentState.commandUsed}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 12),

              // ユニット状態
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _UnitDisplay(
                    label: 'プレイヤー',
                    hp: _currentState.playerHp,
                    units: _currentState.playerUnits,
                    color: Colors.blue,
                  ),
                  _UnitDisplay(
                    label: '敵',
                    hp: _currentState.enemyHp,
                    units: _currentState.enemyUnits,
                    color: Colors.red,
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // イベント説明
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: Colors.grey[100],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'イベント',
                      style: TextStyle(
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                        color: Colors.grey,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _currentState.eventDescription,
                      style: const TextStyle(fontSize: 13),
                    ),
                    if (_currentState.tpAchieved)
                      Padding(
                        padding: const EdgeInsets.only(top: 8),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 8,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: Colors.amber[100],
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: const Text(
                            '✨ ターニングポイント達成',
                            style: TextStyle(
                              fontSize: 11,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFD4A017),
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          ),
        ),

        // プレイバックコントロール
        Container(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              // ターンスライダー
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text('ターン進行'),
                      Text(
                        '${_currentTurnIndex + 1}/${widget.replay.turnStates.length}',
                        style: const TextStyle(fontSize: 12),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Slider(
                    value: _currentTurnIndex.toDouble(),
                    min: 0,
                    max: (widget.replay.turnStates.length - 1).toDouble(),
                    divisions: widget.replay.turnStates.length - 1,
                    onChanged: (value) => _seekToTurn(value.toInt()),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // 再生コントロールボタン
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // 前へ
                  IconButton(
                    icon: const Icon(Icons.skip_previous),
                    onPressed: () => _seekToTurn(0),
                  ),

                  // 再生/一時停止
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.blue,
                      shape: BoxShape.circle,
                    ),
                    child: IconButton(
                      icon: Icon(_isPlaying ? Icons.pause : Icons.play_arrow),
                      color: Colors.white,
                      onPressed: _togglePlayPause,
                    ),
                  ),

                  // 次へ
                  IconButton(
                    icon: const Icon(Icons.skip_next),
                    onPressed: () => _seekToTurn(_currentTurnIndex + 1),
                  ),
                ],
              ),
              const SizedBox(height: 12),

              // 再生速度
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('速度: '),
                  SegmentedButton<int>(
                    segments: const [
                      ButtonSegment(value: 1, label: Text('1x')),
                      ButtonSegment(value: 2, label: Text('2x')),
                      ButtonSegment(value: 4, label: Text('4x')),
                    ],
                    selected: {_playbackSpeed},
                    onSelectionChanged: (value) {
                      setState(() => _playbackSpeed = value.first);
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// ユニット表示タイル
class _UnitDisplay extends StatelessWidget {
  final String label;
  final int hp;
  final int units;
  final Color color;

  const _UnitDisplay({
    required this.label,
    required this.hp,
    required this.units,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          border: Border.all(color: color),
          borderRadius: BorderRadius.circular(8),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              label,
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
            const SizedBox(height: 8),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('HP', style: TextStyle(fontSize: 11)),
                    Text(
                      '$hp',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('兵力', style: TextStyle(fontSize: 11)),
                    Text(
                      '$units',
                      style: const TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
