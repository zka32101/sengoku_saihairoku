import 'package:flutter/material.dart';
import '../../data/models/battle_replay.dart';
import '../../data/models/scenario_data.dart';
import '../../data/models/difficulty_mode.dart';
import '../../data/repositories/replay_repository.dart';
import '../widgets/replay_player.dart';

/// リプレイ一覧・再生画面
class ReplayScreen extends StatefulWidget {
  const ReplayScreen({super.key});

  @override
  State<ReplayScreen> createState() => _ReplayScreenState();
}

class _ReplayScreenState extends State<ReplayScreen> {
  final _replayRepo = ReplayRepository();
  late Future<List<BattleReplay>> _replays;
  late Future<ReplayStats> _stats;
  int _selectedFilter = 0; // 0=全部, 1=勝利, 2=敗北

  @override
  void initState() {
    super.initState();
    _loadReplays();
  }

  void _loadReplays() {
    _replays = _getFilteredReplays();
    _stats = _replayRepo.getStats();
    setState(() {});
  }

  Future<List<BattleReplay>> _getFilteredReplays() async {
    switch (_selectedFilter) {
      case 1:
        return _replayRepo.getVictoryReplays();
      case 2:
        return _replayRepo.getDefeatReplays();
      default:
        return _replayRepo.getAllReplays();
    }
  }

  void _deleteReplay(String id) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('削除確認'),
        content: const Text('このリプレイを削除しますか？'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('キャンセル'),
          ),
          TextButton(
            onPressed: () {
              _replayRepo.deleteReplay(id);
              Navigator.pop(ctx);
              _loadReplays();
            },
            child: const Text('削除', style: TextStyle(color: Colors.red)),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('バトルリプレイ'),
        centerTitle: true,
      ),
      body: FutureBuilder<List<BattleReplay>>(
        future: _replays,
        builder: (context, replaySnapshot) {
          if (!replaySnapshot.hasData) {
            return const Center(child: CircularProgressIndicator());
          }

          final replays = replaySnapshot.data!;

          return CustomScrollView(
            slivers: [
              // 統計情報
              SliverToBoxAdapter(
                child: FutureBuilder<ReplayStats>(
                  future: _stats,
                  builder: (context, statsSnapshot) {
                    if (!statsSnapshot.hasData) {
                      return const SizedBox();
                    }

                    final stats = statsSnapshot.data!;
                    return _ReplayStatsCard(stats: stats);
                  },
                ),
              ),

              // フィルタータブ
              SliverToBoxAdapter(
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  padding: const EdgeInsets.symmetric(horizontal: 8),
                  child: Row(
                    children: [
                      _FilterChip(
                        label: 'すべて',
                        selected: _selectedFilter == 0,
                        onTap: () {
                          setState(() => _selectedFilter = 0);
                          _loadReplays();
                        },
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: '勝利',
                        selected: _selectedFilter == 1,
                        color: Colors.green,
                        onTap: () {
                          setState(() => _selectedFilter = 1);
                          _loadReplays();
                        },
                      ),
                      const SizedBox(width: 8),
                      _FilterChip(
                        label: '敗北',
                        selected: _selectedFilter == 2,
                        color: Colors.red,
                        onTap: () {
                          setState(() => _selectedFilter = 2);
                          _loadReplays();
                        },
                      ),
                    ],
                  ),
                ),
              ),
              const SliverPadding(padding: EdgeInsets.only(top: 8)),

              // リプレイ一覧
              if (replays.isEmpty)
                SliverFillRemaining(
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.videocam_off,
                          size: 64,
                          color: Colors.grey[400],
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'リプレイがありません',
                          style: TextStyle(color: Colors.grey[600]),
                        ),
                      ],
                    ),
                  ),
                )
              else
                SliverList(
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final replay = replays[index];
                      return _ReplayListTile(
                        replay: replay,
                        onTap: () => _showReplayPlayer(replay),
                        onDelete: () => _deleteReplay(replay.id),
                      );
                    },
                    childCount: replays.length,
                  ),
                ),
            ],
          );
        },
      ),
    );
  }

  void _showReplayPlayer(BattleReplay replay) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      builder: (ctx) => DraggableScrollableSheet(
        initialChildSize: 0.9,
        minChildSize: 0.5,
        maxChildSize: 1.0,
        builder: (context, scrollController) => Container(
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: SingleChildScrollView(
            controller: scrollController,
            child: ReplayPlayer(replay: replay),
          ),
        ),
      ),
    );
  }
}

/// リプレイ統計カード
class _ReplayStatsCard extends StatelessWidget {
  final ReplayStats stats;

  const _ReplayStatsCard({required this.stats});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      margin: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [Colors.blue[400]!, Colors.blue[600]!],
        ),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            '総リプレイ数',
            style: TextStyle(fontSize: 12, color: Colors.white70),
          ),
          const SizedBox(height: 4),
          Text(
            '${stats.totalReplays}',
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '勝率',
                    style: TextStyle(fontSize: 11, color: Colors.white70),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${stats.winRate}%',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '平均スコア',
                    style: TextStyle(fontSize: 11, color: Colors.white70),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${stats.averageScore}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    '勝/敗',
                    style: TextStyle(fontSize: 11, color: Colors.white70),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${stats.victories}W/${stats.defeats}L',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// フィルターチップ
class _FilterChip extends StatelessWidget {
  final String label;
  final bool selected;
  final Color? color;
  final VoidCallback onTap;

  const _FilterChip({
    required this.label,
    required this.selected,
    this.color,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return FilterChip(
      label: Text(label),
      selected: selected,
      backgroundColor: Colors.grey[200],
      selectedColor: color ?? Colors.blue,
      labelStyle: TextStyle(
        color: selected ? Colors.white : Colors.black,
        fontWeight: selected ? FontWeight.bold : FontWeight.normal,
      ),
      onSelected: (_) => onTap(),
    );
  }
}

/// リプレイリスト項目
class _ReplayListTile extends StatelessWidget {
  final BattleReplay replay;
  final VoidCallback onTap;
  final VoidCallback onDelete;

  const _ReplayListTile({
    required this.replay,
    required this.onTap,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      child: ListTile(
        leading: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
            color: replay.isVictory ? Colors.green[100] : Colors.red[100],
            borderRadius: BorderRadius.circular(8),
          ),
          child: Center(
            child: Text(
              replay.isVictory ? '🏆' : '💔',
              style: const TextStyle(fontSize: 24),
            ),
          ),
        ),
        title: Text(replay.battleName),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              '${replay.difficulty.displayName} • スコア: ${replay.finalScore}',
              style: const TextStyle(fontSize: 12),
            ),
            Text(
              replay.playedAt.toString().split(' ')[0],
              style: TextStyle(fontSize: 11, color: Colors.grey[600]),
            ),
          ],
        ),
        trailing: PopupMenuButton(
          itemBuilder: (ctx) => [
            PopupMenuItem(
              child: const Text('削除'),
              onTap: onDelete,
            ),
          ],
        ),
        onTap: onTap,
      ),
    );
  }
}
