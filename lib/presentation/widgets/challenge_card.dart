import 'package:flutter/material.dart';
import '../../data/models/daily_challenge.dart';
import '../../data/models/scenario_data.dart';
import '../../data/models/difficulty_mode.dart';

/// 本日のチャレンジを表示するカード
class ChallengeCard extends StatelessWidget {
  final DailyChallenge challenge;
  final ChallengeProgress? progress;
  final VoidCallback onTap;

  const ChallengeCard({
    super.key,
    required this.challenge,
    this.progress,
    required this.onTap,
  });

  String _getDifficultyLabel(DifficultyMode difficulty) {
    return switch (difficulty) {
      DifficultyMode.easy => 'イージー',
      DifficultyMode.normal => 'ノーマル',
      DifficultyMode.hard => 'ハード',
    };
  }

  Color _getDifficultyColor(DifficultyMode difficulty) {
    return switch (difficulty) {
      DifficultyMode.easy => Colors.green,
      DifficultyMode.normal => Colors.blue,
      DifficultyMode.hard => Colors.red,
    };
  }

  String _getScenarioName(Scenario scenario) {
    return switch (scenario) {
      Scenario.odigahara => '桶狭間',
      Scenario.nagashino => '長篠',
      Scenario.honnoJi => '本能寺',
      Scenario.sekigahara => '関ヶ原',
      Scenario.kawanakajima => '川中島',
      Scenario.itsukushima => '厳島',
    };
  }

  @override
  Widget build(BuildContext context) {
    final isCompleted = progress?.isCompleted ?? false;
    final isClaimed = progress?.claimed ?? false;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isCompleted ? Colors.green : const Color(0xFFFFD700),
            width: 2,
          ),
        ),
        color: const Color(0xFF1A1A1A),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ヘッダー：タイトルと達成状態
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          challenge.title,
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFD700),
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                        const SizedBox(height: 4),
                        Text(
                          challenge.description,
                          style: TextStyle(
                            fontSize: 12,
                            color: Colors.grey[400],
                          ),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  if (isCompleted)
                    Icon(
                      isClaimed ? Icons.check_circle : Icons.radio_button_checked,
                      color: Colors.green,
                      size: 28,
                    ),
                ],
              ),
              const SizedBox(height: 12),
              // シナリオと難易度
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF333333),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _getScenarioName(challenge.scenario),
                      style: const TextStyle(
                        fontSize: 12,
                        color: Colors.white,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                    decoration: BoxDecoration(
                      color: _getDifficultyColor(challenge.difficulty)
                          .withOpacity(0.2),
                      border: Border.all(
                        color: _getDifficultyColor(challenge.difficulty),
                      ),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      _getDifficultyLabel(challenge.difficulty),
                      style: TextStyle(
                        fontSize: 12,
                        color: _getDifficultyColor(challenge.difficulty),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 12),
              // 達成条件
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF2A2A2A),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Text(
                  challenge.conditionDescription,
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey[300],
                    height: 1.6,
                  ),
                ),
              ),
              const SizedBox(height: 12),
              // 報酬
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  _RewardItem(
                    icon: Icons.monetization_on,
                    label: '報酬',
                    value: challenge.baseReward.toString(),
                    color: const Color(0xFFFFD700),
                  ),
                  _RewardItem(
                    icon: Icons.star,
                    label: 'AP',
                    value: challenge.achievementPoints.toString(),
                    color: Colors.amber,
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

/// 報酬表示用の小さなコンポーネント
class _RewardItem extends StatelessWidget {
  final IconData icon;
  final String label;
  final String value;
  final Color color;

  const _RewardItem({
    required this.icon,
    required this.label,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(width: 4),
        Text(
          '$label:',
          style: const TextStyle(fontSize: 11, color: Colors.grey),
        ),
        const SizedBox(width: 4),
        Text(
          value,
          style: TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
      ],
    );
  }
}
