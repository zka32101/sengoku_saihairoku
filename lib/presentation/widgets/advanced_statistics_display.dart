import 'package:flutter/material.dart';
import '../../data/models/advanced_statistics.dart';
import '../../data/models/scenario_data.dart';
import '../../data/models/difficulty_mode.dart';

/// シナリオ別パフォーマンスカード
class ScenarioPerformanceCard extends StatelessWidget {
  final ScenarioPerformance performance;

  const ScenarioPerformanceCard({
    super.key,
    required this.performance,
  });

  @override
  Widget build(BuildContext context) {
    final winRatePercent = (performance.winRate * 100).toStringAsFixed(1);
    final winRateColor = performance.winRate > 0.6
        ? Colors.green
        : performance.winRate > 0.4
            ? Colors.orange
            : Colors.red;

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ヘッダー
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        performance.scenario.displayNameJa,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Container(
                        padding: const EdgeInsets.symmetric(
                          horizontal: 8,
                          vertical: 4,
                        ),
                        decoration: BoxDecoration(
                          color: Colors.amber[100],
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Text(
                          performance.masteryStatus,
                          style: const TextStyle(
                            fontSize: 11,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFD4A017),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    Text(
                      '$winRatePercent%',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: winRateColor,
                      ),
                    ),
                    Text(
                      '勝率',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.grey[600],
                      ),
                    ),
                  ],
                ),
              ],
            ),

            const SizedBox(height: 16),
            const Divider(),
            const SizedBox(height: 12),

            // 統計情報
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                _StatColumn(
                  label: '戦闘数',
                  value: '${performance.totalBattles}',
                ),
                _StatColumn(
                  label: '勝利',
                  value: '${performance.victories}',
                  color: Colors.green,
                ),
                _StatColumn(
                  label: '敗北',
                  value: '${performance.defeats}',
                  color: Colors.red,
                ),
                _StatColumn(
                  label: '最高スコア',
                  value: '${performance.bestScore}',
                ),
              ],
            ),

            const SizedBox(height: 16),

            // 難易度別タブ
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: [
                  for (final difficulty in DifficultyMode.values)
                    if (performance.byDifficulty.containsKey(difficulty))
                      Padding(
                        padding: const EdgeInsets.only(right: 8),
                        child: _DifficultyBadge(
                          difficulty: difficulty,
                          performance: performance.byDifficulty[difficulty]!,
                        ),
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

/// 統計列
class _StatColumn extends StatelessWidget {
  final String label;
  final String value;
  final Color? color;

  const _StatColumn({
    required this.label,
    required this.value,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: TextStyle(
            fontSize: 11,
            color: Colors.grey[600],
          ),
        ),
      ],
    );
  }
}

/// 難易度バッジ
class _DifficultyBadge extends StatelessWidget {
  final DifficultyMode difficulty;
  final DifficultyPerformance performance;

  const _DifficultyBadge({
    required this.difficulty,
    required this.performance,
  });

  @override
  Widget build(BuildContext context) {
    final winRatePercent = (performance.winRate * 100).toStringAsFixed(0);
    final bgColor = performance.victoryCount > 0 ? Colors.blue[50] : Colors.grey[50];
    final borderColor = performance.victoryCount > 0 ? Colors.blue : Colors.grey;

    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(color: borderColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(
            difficulty.displayName,
            style: const TextStyle(
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            '$winRatePercent%',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
              color: borderColor,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            '${performance.victoryCount}W',
            style: const TextStyle(fontSize: 10),
          ),
        ],
      ),
    );
  }
}

/// 難易度比較カード
class DifficultyComparisonCard extends StatelessWidget {
  final DifficultyStats difficultyStats;

  const DifficultyComparisonCard({
    super.key,
    required this.difficultyStats,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              '難易度別分析',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            for (final difficulty in DifficultyMode.values)
              if (difficultyStats.getStats(difficulty) != null)
                _DifficultyComparisonRow(
                  stats: difficultyStats.getStats(difficulty)!,
                ),
          ],
        ),
      ),
    );
  }
}

/// 難易度比較行
class _DifficultyComparisonRow extends StatelessWidget {
  final DifficultyModeStats stats;

  const _DifficultyComparisonRow({required this.stats});

  @override
  Widget build(BuildContext context) {
    final winRatePercent = (stats.winRate * 100).toStringAsFixed(1);

    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                stats.difficulty.displayName,
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              Text(
                '$winRatePercent%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: stats.winRate,
              minHeight: 8,
              backgroundColor: Colors.grey[300],
              valueColor: AlwaysStoppedAnimation(
                stats.winRate > 0.6
                    ? Colors.green
                    : stats.winRate > 0.4
                        ? Colors.orange
                        : Colors.red,
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${stats.victories}勝 ${stats.defeats}敗 (${stats.totalBattles}戦)',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
              Text(
                '${stats.scenariosCleared}/5制覇',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.blue[600],
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

/// ランキングカード
class ScenarioRankingCard extends StatelessWidget {
  final List<ScenarioPerformance> ranking;

  const ScenarioRankingCard({
    super.key,
    required this.ranking,
  });

  @override
  Widget build(BuildContext context) {
    if (ranking.isEmpty) {
      return Card(
        margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Center(
            child: Text(
              'データなし',
              style: TextStyle(color: Colors.grey[600]),
            ),
          ),
        ),
      );
    }

    return Card(
      margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'シナリオランキング (勝率)',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 16),
            for (int i = 0; i < ranking.length; i++)
              _RankingItem(
                rank: i + 1,
                performance: ranking[i],
              ),
          ],
        ),
      ),
    );
  }
}

/// ランキング項目
class _RankingItem extends StatelessWidget {
  final int rank;
  final ScenarioPerformance performance;

  const _RankingItem({
    required this.rank,
    required this.performance,
  });

  @override
  Widget build(BuildContext context) {
    final winRatePercent = (performance.winRate * 100).toStringAsFixed(1);
    final medal = rank == 1 ? '🥇' : rank == 2 ? '🥈' : rank == 3 ? '🥉' : '$rank位';

    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: Row(
        children: [
          SizedBox(
            width: 40,
            child: Text(
              medal,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  performance.scenario.displayNameJa,
                  style: const TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  '${performance.victories}勝 ${performance.defeats}敗',
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey[600],
                  ),
                ),
              ],
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '$winRatePercent%',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
              Text(
                '平均 ${performance.averageScore}pt',
                style: TextStyle(
                  fontSize: 11,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
