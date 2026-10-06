import 'package:flutter/material.dart';
import '../../data/models/achievement.dart';

/// Sprint 3 Achievement Card
class AchievementCard extends StatelessWidget {
  final Achievement achievement;
  final bool isUnlocked;
  final VoidCallback? onTap;

  const AchievementCard({
    super.key,
    required this.achievement,
    required this.isUnlocked,
    this.onTap,
  });

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

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        color: isUnlocked ? const Color(0xFF2A1A0A) : const Color(0xFF1A0F0A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: isUnlocked ? const Color(0xFF8B6914) : Colors.grey[700]!,
            width: 1,
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            gradient: isUnlocked
                ? LinearGradient(
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                    colors: [
                      const Color(0xFF2A1A0A),
                      const Color(0xFF1A0F0A),
                    ],
                  )
                : null,
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Header with lock/unlock badge
              Padding(
                padding: const EdgeInsets.all(8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    // Difficulty badge
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 6,
                        vertical: 3,
                      ),
                      decoration: BoxDecoration(
                        color: _getDifficultyColor(achievement.difficulty)
                            .withOpacity(0.2),
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(
                          color: _getDifficultyColor(achievement.difficulty),
                          width: 0.5,
                        ),
                      ),
                      child: Text(
                        _getDifficultyLabel(achievement.difficulty),
                        style: TextStyle(
                          fontSize: 8,
                          fontWeight: FontWeight.bold,
                          color:
                              _getDifficultyColor(achievement.difficulty),
                        ),
                      ),
                    ),
                    // Unlock status
                    Icon(
                      isUnlocked ? Icons.check_circle : Icons.lock,
                      size: 16,
                      color: isUnlocked ? Colors.green : Colors.grey,
                    ),
                  ],
                ),
              ),

              // Icon and name
              Expanded(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    if (achievement.icon != null)
                      Text(
                        achievement.icon!,
                        style: const TextStyle(fontSize: 40),
                      )
                    else
                      Icon(
                        Icons.emoji_events,
                        size: 40,
                        color: isUnlocked ? Colors.amber : Colors.grey,
                      ),
                    const SizedBox(height: 8),
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 4),
                      child: Text(
                        achievement.name,
                        style: TextStyle(
                          fontSize: 12,
                          fontWeight: FontWeight.bold,
                          color: isUnlocked
                              ? const Color(0xFFFFD700)
                              : const Color(0xFFB0A090),
                        ),
                        textAlign: TextAlign.center,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                      ),
                    ),
                  ],
                ),
              ),

              // Footer with points
              if (isUnlocked && achievement.points != null)
                Padding(
                  padding: const EdgeInsets.all(8),
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 6,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: const Color(0xFF3A2A1A),
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Text(
                      '+${achievement.points}pt',
                      style: const TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFFFFD700),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                )
              else
                const SizedBox(height: 8),
            ],
          ),
        ),
      ),
    );
  }

  String _getDifficultyLabel(AchievementDifficulty difficulty) {
    switch (difficulty) {
      case AchievementDifficulty.bronze:
        return 'BRONZE';
      case AchievementDifficulty.silver:
        return 'SILVER';
      case AchievementDifficulty.gold:
        return 'GOLD';
      case AchievementDifficulty.diamond:
        return 'DIAMOND';
    }
  }
}

