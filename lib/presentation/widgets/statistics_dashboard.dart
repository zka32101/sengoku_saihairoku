import 'package:flutter/material.dart';
import '../../data/models/game_statistics.dart';
import '../../data/models/achievement.dart';
import '../../l10n/generated/app_localizations.dart';
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
    final l10n = AppLocalizations.of(context)!;
    final playerRank = PlayerRank.fromPoints(totalAchievementPoints);
    final unlockedAchievements =
        achievements.where((a) => a.isUnlocked).length;

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
            l10n: l10n,
          ),
          const SizedBox(height: 16),

          // 主要統計
          Text(
            l10n.statsDashboardCombatStatsTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          _StatisticsGrid(statistics: statistics, l10n: l10n),
          const SizedBox(height: 16),

          // 時間統計
          Text(
            l10n.statsDashboardPlayTimeTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          _PlayTimeCard(statistics: statistics, l10n: l10n),
          const SizedBox(height: 16),

          // スコア統計
          Text(
            l10n.statsDashboardScoreTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          _ScoreStatisticsCard(statistics: statistics, l10n: l10n),
          const SizedBox(height: 16),

          // 勝率グラフ
          Text(
            l10n.statsDashboardWinRateAnalysisTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          _WinRateIndicator(winRate: statistics.winRate, l10n: l10n),
          const SizedBox(height: 16),

          // ターニングポイント統計
          Text(
            l10n.statsDashboardTurningPointTitle,
            style: Theme.of(context).textTheme.titleMedium,
          ),
          const SizedBox(height: 12),
          _TPStatisticsCard(statistics: statistics, l10n: l10n),
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
              label: Text(l10n.statsDashboardViewDetailsButton),
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
  final AppLocalizations l10n;

  const _PlayerRankCard({
    required this.rank,
    required this.points,
    required this.achievements,
    required this.totalAchievements,
    required this.l10n,
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
              l10n.statsDashboardPointsSuffix(points),
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
                l10n.statsDashboardAchievementsLine(achievements, totalAchievements),
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
  final AppLocalizations l10n;

  const _StatisticsGrid({required this.statistics, required this.l10n});

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
          label: l10n.statsDashboardTotalBattlesLabel,
          value: '${statistics.totalBattles}',
          icon: '⚔️',
        ),
        _StatisticTile(
          label: l10n.statsDashboardTotalWinsLabel,
          value: '${statistics.totalWins}',
          icon: '🏆',
        ),
        _StatisticTile(
          label: l10n.statsDashboardTotalLossesLabel,
          value: '${statistics.totalLosses}',
          icon: '💔',
        ),
        _StatisticTile(
          label: l10n.statsDashboardTpAchievedLabel,
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
  final AppLocalizations l10n;

  const _PlayTimeCard({required this.statistics, required this.l10n});

  String _formatDuration(Duration d) {
    final hours = d.inHours;
    final minutes = d.inMinutes.remainder(60);
    final seconds = d.inSeconds.remainder(60);
    if (hours > 0) {
      return l10n.statsDashboardDurationHoursMinutes(hours, minutes);
    } else if (minutes > 0) {
      return l10n.statsDashboardDurationMinutesSeconds(minutes, seconds);
    } else {
      return l10n.statsDashboardDurationSeconds(seconds);
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
                    Text(l10n.statsDashboardTotalPlayTimeLabel),
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
                    Text(l10n.statsDashboardAveragePlayTimeLabel),
                    Text(
                      l10n.statsDashboardAverageBattleMinutes(
                          (statistics.averageBattleDuration.inSeconds / 60)
                              .toStringAsFixed(1)),
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
                  l10n.statsDashboardFirstPlayLine(
                      statistics.firstBattleAt.toString().split(' ')[0]),
                  style: Theme.of(context).textTheme.bodySmall,
                ),
                Text(
                  l10n.statsDashboardLastPlayLine(
                      statistics.lastBattleAt.toString().split(' ')[0]),
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
  final AppLocalizations l10n;

  const _ScoreStatisticsCard({required this.statistics, required this.l10n});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            _ScoreStat(
              label: l10n.statsDashboardTotalScoreLabel,
              value: statistics.totalScore,
              isTotal: true,
            ),
            const SizedBox(height: 12),
            const Divider(),
            const SizedBox(height: 12),
            _ScoreStat(
              label: l10n.statsDashboardAverageScoreLabel,
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
  final AppLocalizations l10n;

  const _WinRateIndicator({required this.winRate, required this.l10n});

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
                Text(l10n.statsDashboardWinRateLabel),
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
  final AppLocalizations l10n;

  const _TPStatisticsCard({required this.statistics, required this.l10n});

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
                Text(l10n.statsDashboardTotalTpLabel),
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
                Text(l10n.statsDashboardAverageTpLabel),
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
