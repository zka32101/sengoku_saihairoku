import 'package:flutter/material.dart';
import '../../data/models/achievement.dart';

class AchievementDetailView extends StatelessWidget {
  final Achievement achievement;
  final bool isUnlocked;

  const AchievementDetailView({
    super.key,
    required this.achievement,
    required this.isUnlocked,
  });

  String _getCategoryLabel(AchievementCategory category) {
    switch (category) {
      case AchievementCategory.combat:
        return '戦闘';
      case AchievementCategory.progression:
        return '進行度';
      case AchievementCategory.prestige:
        return 'プレスティジ';
      case AchievementCategory.cosmetic:
        return 'コスメティック';
      case AchievementCategory.milestone:
        return 'マイルストーン';
      case AchievementCategory.event:
        return 'イベント';
    }
  }

  String _getDifficultyLabel(AchievementDifficulty difficulty) {
    switch (difficulty) {
      case AchievementDifficulty.bronze:
        return 'ブロンズ';
      case AchievementDifficulty.silver:
        return 'シルバー';
      case AchievementDifficulty.gold:
        return 'ゴールド';
      case AchievementDifficulty.diamond:
        return 'ダイヤモンド';
    }
  }

  Color _getDifficultyColor(AchievementDifficulty difficulty) {
    switch (difficulty) {
      case AchievementDifficulty.bronze:
        return const Color(0xFFCD7F32);
      case AchievementDifficulty.silver:
        return const Color(0xFFC0C0C0);
      case AchievementDifficulty.gold:
        return const Color(0xFFFFD700);
      case AchievementDifficulty.diamond:
        return const Color(0xFF00D4FF);
    }
  }

  String _getConditionLabel(AchievementConditionType conditionType) {
    switch (conditionType) {
      case AchievementConditionType.battleWins:
        return '戦闘勝利';
      case AchievementConditionType.levelReached:
        return 'レベル到達';
      case AchievementConditionType.prestigeRank:
        return 'プレスティジランク';
      case AchievementConditionType.turnEfficiency:
        return 'ターン効率';
      case AchievementConditionType.cosmeticUnlocked:
        return 'コスメティック解放';
      case AchievementConditionType.totalPlayTime:
        return 'プレイ時間';
      case AchievementConditionType.scenarioCleared:
        return 'シナリオクリア';
      case AchievementConditionType.perfectBattle:
        return 'パーフェクト戦闘';
    }
  }

  String _getConditionDescription(
    AchievementConditionType conditionType,
    int conditionValue,
  ) {
    switch (conditionType) {
      case AchievementConditionType.battleWins:
        return '$conditionValue 回の戦闘に勝利';
      case AchievementConditionType.levelReached:
        return 'レベル $conditionValue に到達';
      case AchievementConditionType.prestigeRank:
        return 'プレスティジランク $conditionValue';
      case AchievementConditionType.turnEfficiency:
        return '$conditionValue ターン以内にクリア';
      case AchievementConditionType.cosmeticUnlocked:
        return '$conditionValue 個のコスメティックを解放';
      case AchievementConditionType.totalPlayTime:
        return '総プレイ時間 $conditionValue 時間';
      case AchievementConditionType.scenarioCleared:
        return 'シナリオをクリア';
      case AchievementConditionType.perfectBattle:
        return 'ユニットロスなしでクリア';
    }
  }

  @override
  Widget build(BuildContext context) {
    return DraggableScrollableSheet(
      expand: false,
      initialChildSize: 0.7,
      minChildSize: 0.5,
      maxChildSize: 0.95,
      builder: (context, scrollController) => Container(
        decoration: const BoxDecoration(
          color: Color(0xFF2A1A0A),
          borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          border: Border(
            top: BorderSide(color: Color(0xFF8B6914), width: 1),
          ),
        ),
        child: ListView(
          controller: scrollController,
          padding: const EdgeInsets.all(20),
          children: [
            // Close button
            Align(
              alignment: Alignment.topRight,
              child: IconButton(
                icon: const Icon(Icons.close, color: Color(0xFFE8D5B0)),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            const SizedBox(height: 16),

            // Achievement Header
            Center(
              child: Column(
                children: [
                  // Icon
                  if (achievement.icon != null)
                    Text(
                      achievement.icon!,
                      style: const TextStyle(fontSize: 64),
                    ),
                  const SizedBox(height: 16),

                  // Name
                  Text(
                    achievement.name,
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFD700),
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 8),

                  // Status Badge
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: isUnlocked
                          ? const Color(0xFF1A3A1A)
                          : const Color(0xFF3A1A1A),
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: isUnlocked ? Colors.green : Colors.red,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      isUnlocked ? 'クリア済み' : 'ロック中',
                      style: TextStyle(
                        color: isUnlocked ? Colors.green : Colors.red,
                        fontSize: 12,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 24),

            // Metadata
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: const Color(0xFF1A0F0A),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(color: const Color(0xFF8B6914), width: 1),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Category and Difficulty
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'カテゴリー',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFFB0A090),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getCategoryLabel(achievement.category),
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.bold,
                              color: Color(0xFFE8D5B0),
                            ),
                          ),
                        ],
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            '難易度',
                            style: TextStyle(
                              fontSize: 12,
                              color: Color(0xFFB0A090),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: _getDifficultyColor(achievement.difficulty)
                                  .withOpacity(0.2),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: _getDifficultyColor(achievement.difficulty),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              _getDifficultyLabel(achievement.difficulty),
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.bold,
                                color: _getDifficultyColor(achievement.difficulty),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  if (achievement.points != null) ...[
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'ポイント',
                          style: TextStyle(
                            fontSize: 12,
                            color: Color(0xFFB0A090),
                          ),
                        ),
                        Text(
                          '${achievement.points} pt',
                          style: const TextStyle(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFFFFD700),
                          ),
                        ),
                      ],
                    ),
                  ],
                ],
              ),
            ),
            const SizedBox(height: 20),

            // Description
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '説明',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFD700),
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  achievement.description,
                  style: const TextStyle(
                    fontSize: 13,
                    color: Color(0xFFE8D5B0),
                    height: 1.5,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 20),

            // Conditions
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  '達成条件',
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: Color(0xFFFFD700),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1A0F0A),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: const Color(0xFF8B6914),
                      width: 1,
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _getConditionLabel(achievement.conditionType),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFB0A090),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _getConditionDescription(
                          achievement.conditionType,
                          achievement.conditionValue,
                        ),
                        style: const TextStyle(
                          fontSize: 13,
                          color: Color(0xFFE8D5B0),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (achievement.reward != null) ...[
              const SizedBox(height: 20),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    '報酬',
                    style: TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFFFFD700),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      color: const Color(0xFF1A3A1A),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: Colors.green,
                        width: 1,
                      ),
                    ),
                    child: Text(
                      achievement.reward!,
                      style: const TextStyle(
                        fontSize: 13,
                        color: Colors.green,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
