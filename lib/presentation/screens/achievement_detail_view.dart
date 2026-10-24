import 'package:flutter/material.dart';
import '../../data/models/achievement.dart';
import '../../l10n/generated/app_localizations.dart';

class AchievementDetailView extends StatelessWidget {
  final Achievement achievement;
  final bool isUnlocked;

  const AchievementDetailView({
    super.key,
    required this.achievement,
    required this.isUnlocked,
  });

  String _getCategoryLabel(AppLocalizations l10n, AchievementCategory category) {
    switch (category) {
      case AchievementCategory.combat:
        return l10n.achievementCategoryCombat;
      case AchievementCategory.progression:
        return l10n.achievementCategoryProgression;
      case AchievementCategory.prestige:
        return l10n.achievementCategoryPrestige;
      case AchievementCategory.cosmetic:
        return l10n.achievementCategoryCosmetic;
      case AchievementCategory.milestone:
        return l10n.achievementCategoryMilestone;
      case AchievementCategory.event:
        return l10n.achievementCategoryEvent;
    }
  }

  String _getDifficultyLabel(AppLocalizations l10n, AchievementDifficulty difficulty) {
    switch (difficulty) {
      case AchievementDifficulty.bronze:
        return l10n.achievementDifficultyBronze;
      case AchievementDifficulty.silver:
        return l10n.achievementDifficultySilver;
      case AchievementDifficulty.gold:
        return l10n.achievementDifficultyGold;
      case AchievementDifficulty.diamond:
        return l10n.achievementDifficultyDiamond;
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

  String _getConditionLabel(AppLocalizations l10n, AchievementConditionType conditionType) {
    switch (conditionType) {
      case AchievementConditionType.battleWins:
        return l10n.achievementConditionBattleWins;
      case AchievementConditionType.levelReached:
        return l10n.achievementConditionLevelReached;
      case AchievementConditionType.prestigeRank:
        return l10n.achievementConditionPrestigeRank;
      case AchievementConditionType.turnEfficiency:
        return l10n.achievementConditionTurnEfficiency;
      case AchievementConditionType.cosmeticUnlocked:
        return l10n.achievementConditionCosmeticUnlocked;
      case AchievementConditionType.totalPlayTime:
        return l10n.achievementConditionTotalPlayTime;
      case AchievementConditionType.scenarioCleared:
        return l10n.achievementConditionScenarioCleared;
      case AchievementConditionType.perfectBattle:
        return l10n.achievementConditionPerfectBattle;
      case AchievementConditionType.prestigeResetCount:
        return l10n.achievementConditionPrestigeResetCount;
      case AchievementConditionType.eventChallengeCompleted:
        return l10n.achievementConditionEventChallengeCompleted;
      case AchievementConditionType.warlordsCollected:
        return l10n.achievementConditionWarlordsCollected;
    }
  }

  String _getConditionDescription(
    AppLocalizations l10n,
    AchievementConditionType conditionType,
    int conditionValue,
  ) {
    switch (conditionType) {
      case AchievementConditionType.battleWins:
        return l10n.achievementDescBattleWins(conditionValue);
      case AchievementConditionType.levelReached:
        return l10n.achievementDescLevelReached(conditionValue);
      case AchievementConditionType.prestigeRank:
        return l10n.achievementDescPrestigeRank(conditionValue);
      case AchievementConditionType.turnEfficiency:
        return l10n.achievementDescTurnEfficiency(conditionValue);
      case AchievementConditionType.cosmeticUnlocked:
        return l10n.achievementDescCosmeticUnlocked(conditionValue);
      case AchievementConditionType.totalPlayTime:
        return l10n.achievementDescTotalPlayTime(conditionValue);
      case AchievementConditionType.scenarioCleared:
        return l10n.achievementDescScenarioCleared;
      case AchievementConditionType.perfectBattle:
        return l10n.achievementDescPerfectBattle;
      case AchievementConditionType.prestigeResetCount:
        return l10n.achievementDescPrestigeResetCount(conditionValue);
      case AchievementConditionType.eventChallengeCompleted:
        return l10n.achievementDescEventChallengeCompleted(conditionValue);
      case AchievementConditionType.warlordsCollected:
        return l10n.achievementDescWarlordsCollected(conditionValue);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
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
                      isUnlocked
                          ? l10n.achievementDetailUnlockedBadge
                          : l10n.achievementDetailLockedBadge,
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
                          Text(
                            l10n.achievementDetailCategoryLabel,
                            style: const TextStyle(
                              fontSize: 12,
                              color: Color(0xFFB0A090),
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            _getCategoryLabel(l10n, achievement.category),
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
                          Text(
                            l10n.achievementDetailDifficultyLabel,
                            style: const TextStyle(
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
                                  .withValues(alpha: 0.2),
                              borderRadius: BorderRadius.circular(4),
                              border: Border.all(
                                color: _getDifficultyColor(achievement.difficulty),
                                width: 1,
                              ),
                            ),
                            child: Text(
                              _getDifficultyLabel(l10n, achievement.difficulty),
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
                        Text(
                          l10n.achievementDetailPointsLabel,
                          style: const TextStyle(
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
                Text(
                  l10n.achievementDetailDescriptionLabel,
                  style: const TextStyle(
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
                Text(
                  l10n.achievementDetailConditionLabel,
                  style: const TextStyle(
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
                        _getConditionLabel(l10n, achievement.conditionType),
                        style: const TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFFB0A090),
                        ),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _getConditionDescription(
                          l10n,
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
                  Text(
                    l10n.achievementDetailRewardLabel,
                    style: const TextStyle(
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
