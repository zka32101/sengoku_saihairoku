import 'package:flutter/material.dart';
import '../../data/models/game_statistics.dart';
import '../../data/models/achievement.dart';
import '../screens/advanced_statistics_screen.dart';

/// ゲーム統計ダッシュボード
class StatisticsDashboard extends StatelessWidget {
  final GameStatistics statistics;
  final List<AchievementProgress> achievements;
  final int totalAchievementPoints;

  const StatisticsDashboard({
    super.key,
    required this.statistics,
    required this.achievements,
    required this.totalAchievementPoints,
  });

  @override
  Widget build(BuildContext context) {
    final playerRank = PlayerRank.fromPoints(totalAchievementPoints);
    final unlockedAchievements =
        achievements.where((a) => a.unlocked).length;

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // プレイヤーランク
          _PlayerRankCard(
            rank: playerRank,
            points: totalAchievementPoints,
            achievements: unlockedAchievements,
            totalAchievements: achievements.length,
          ),
          const SizedBox(height: 16),

          // 主要統計
          Text(
            '戦闘統計',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          _StatisticsGrid(statistics: statistics),
          const SizedBox(height: 16),

          // 時間統計
          Text(
            'プレイ時間',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          _PlayTimeCard(statistics: statistics),
          const SizedBox(height: 16),

          // スコア統計
          Text(
            'スコア',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          _ScoreStatisticsCard(statistics: statistics),
          const SizedBox(height: 16),

          // 勝率グラフ
          Text(
            '勝率分析',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          _WinRateIndicator(winRate: statistics.winRate),
          const SizedBox(height: 16),

          // ターニングポイント統計
          Text(
            'ターニングポイント',
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          _TPStatisticsCard(statistics: statistics),
          const SizedBox(height: 24),

          // 詳細統計ボタン
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => const AdvancedStatisticsScreen(),
                ),
              ),
              icon: const Icon(Icons.analytics),
              label: const Text('詳細統計を見る'),
              style: ElevatedButton.styleFrom(
                padding: const EdgeInsets.symmetric(vertical: 12),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

/// プレイヤーランクカード
class _PlayerRankCard extends StatelessWidget {
  final PlayerRank rank;
  final int points;
  final int achievements;
  final int totalAchievements;

  const _PlayerRankCard({
    required this.rank,
    required this.points,
    required this.achievements,
    required this.totalAchievements,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Text(
              rank.icon,
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 12),
            Text(
              rank.displayName,
              style: Theme.of(context).textTheme.titleLarge,
            ),
            const SizedBox(height: 8),
            Text(
              '$points ポイント',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.amber,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 12),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: Colors.grey[100],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                'アチーブメント: $achievements/$totalAchievements',
                style: Theme.of(context).textTheme.bodySmall,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

/// 統計グリッド
class _StatisticsGrid extends StatelessWidget {
  final GameStatistics statistics;

  const _StatisticsGrid({required this.statistics});

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: [
        _StatisticTile(
          label: '総戦闘数',
          value: '${statistics.totalBattles}',
          icon: '⚔️',
        ),
        _StatisticTile(
          label: '勝利数',
          value: '${statistics.totalWins}',
          icon: '🏆',
        ),
        _StatisticTile(
          label: '敗北数',
          value: '${statistics.totalLosses}',
          icon: '💔',
        ),
        _StatisticTile(
          label: 'TP達成数',
          value: '${statistics.totalTPsAchieved}',
          icon: '📍',
        ),
      ],
    );
  }
}

/// プレイ時間カード
class _PlayTimeCard extends StatelessWidget {
  final GameStatistics statistics;

  const _PlayTimeCard({required this.statistics});

  String _formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    if (hours > 0) {
      return '${hours}時間 ${minutes}分';
    } else if (minutes > 0) {
      return '${minutes}分 ${seconds}秒';
    } else {
      return '${seconds}秒';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text('総プレイ時間'),
                    Text(
                      _formatDuration(statistics.totalPlayTime),
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    const Text('平均戦闘時間'),
                    Text(
                      '${(statistics.averageBattleDuration.inSeconds / 60).toStringAsFixed(1)}分',
                      style: const TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ],
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  '初プレイ: ${statistics.firstBattleAt.toString().split(' ')[0]}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  '最終プレイ: ${statistics.lastBattleAt.toString().split(' ')[0]}',
                  style: Theme.of(context).textTheme.bodySmall,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// スコア統計カード
class _ScoreStatisticsCard extends StatelessWidget {
  final GameStatistics statistics;

  const _ScoreStatisticsCard({required this.statistics});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _ScoreStat(
              label: '総スコア',
              value: statistics.totalScore,
              isTotal: true,
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            _ScoreStat(
              label: '平均スコア',
              value: statistics.averageScore,
            ),
          ],
        ),
      ),
    );
  }
}

/// スコア表示
class _ScoreStat extends StatelessWidget {
  final String label;
  final int value;
  final bool isTotal;

  const _ScoreStat({
    required this.label,
    required this.value,
    this.isTotal = false,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label),
        Text(
          '$value',
          style: TextStyle(
            fontSize: isTotal ? 20 : 16,
            fontWeight: FontWeight.bold,
            color: Colors.amber[700],
          ),
        ),
      ],
    );
  }
}

/// 勝率インジケーター
class _WinRateIndicator extends StatelessWidget {
  final double winRate;

  const _WinRateIndicator({required this.winRate});

  @override
  Widget build(BuildContext context) {
    final percentage = (winRate * 100).toStringAsFixed(1);
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: winRate,
                minHeight: 24,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation(
                  winRate > 0.6
                      ? Colors.green
                      : winRate > 0.4
                          ? Colors.orange
                          : Colors.red,
                ),
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text('勝率'),
                Text(
                  '$percentage%',
                  style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// TP統計カード
class _TPStatisticsCard extends StatelessWidget {
  final GameStatistics statistics;

  const _TPStatisticsCard({required this.statistics});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('総達成数'),
                Text(
                  '${statistics.totalTPsAchieved}',
                  style: const TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                const Text('平均達成数'),
                Text(
                  statistics.totalBattles > 0
                      ? (statistics.totalTPsAchieved / statistics.totalBattles)
                          .toStringAsFixed(2)
                      : '0',
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

/// 統計タイル
class _StatisticTile extends StatelessWidget {
  final String label;
  final String value;
  final String icon;

  const _StatisticTile({
    required this.label,
    required this.value,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(height: 8),
            Text(
              value,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: Theme.of(context).textTheme.bodySmall,
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}
