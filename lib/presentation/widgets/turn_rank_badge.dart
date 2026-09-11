import 'package:flutter/material.dart';
import '../../data/models/turn_efficiency.dart';

/// ターンランク表示バッジウィジェット
class TurnRankBadge extends StatelessWidget {
  final TurnRankResult rankResult;
  final bool showRewardText;

  const TurnRankBadge({
    super.key,
    required this.rankResult,
    this.showRewardText = true,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getRankColor(rankResult.rank);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(color: color, width: 2),
      ),
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // ランクアイコンと名前
            Text(
              rankResult.rank.icon,
              style: const TextStyle(fontSize: 48),
            ),
            const SizedBox(height: 12),
            Text(
              rankResult.rank.displayName,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    color: color,
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: 8),

            // ターン数表示
            Text(
              '${rankResult.turnCount} ターン',
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Colors.grey[600],
                  ),
            ),
            const SizedBox(height: 16),

            // 効率スコアバー
            ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child: LinearProgressIndicator(
                value: rankResult.efficiencyScore,
                minHeight: 8,
                backgroundColor: Colors.grey[300],
                valueColor: AlwaysStoppedAnimation(color),
              ),
            ),
            const SizedBox(height: 8),
            Text(
              '効率: ${(rankResult.efficiencyScore * 100).toStringAsFixed(1)}%',
              style: Theme.of(context).textTheme.bodySmall,
            ),

            if (showRewardText) ...[
              const SizedBox(height: 16),
              const Divider(),
              const SizedBox(height: 12),
              Text(
                rankResult.rewardText,
                style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber[700],
                    ),
              ),
            ]
          ],
        ),
      ),
    );
  }

  Color _getRankColor(TurnRank rank) {
    switch (rank) {
      case TurnRank.gold:
        return Colors.amber;
      case TurnRank.silver:
        return Colors.grey[400]!;
      case TurnRank.bronze:
        return Colors.brown[400]!;
    }
  }
}

/// ターンランク表示パネル（コンパクト版）
class TurnRankPanel extends StatelessWidget {
  final TurnRankResult rankResult;

  const TurnRankPanel({
    super.key,
    required this.rankResult,
  });

  @override
  Widget build(BuildContext context) {
    final color = _getRankColor(rankResult.rank);

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        border: Border.all(color: color, width: 1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Text(
                    rankResult.rank.icon,
                    style: const TextStyle(fontSize: 24),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    rankResult.rank.displayName,
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: color,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                '${rankResult.turnCount} ターン',
                style: TextStyle(
                  fontSize: 12,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Text(
                '${(rankResult.efficiencyScore * 100).toStringAsFixed(0)}%',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
              Text(
                '効率',
                style: TextStyle(
                  fontSize: 10,
                  color: Colors.grey[600],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getRankColor(TurnRank rank) {
    switch (rank) {
      case TurnRank.gold:
        return Colors.amber;
      case TurnRank.silver:
        return Colors.grey[400]!;
      case TurnRank.bronze:
        return Colors.brown[400]!;
    }
  }
}
