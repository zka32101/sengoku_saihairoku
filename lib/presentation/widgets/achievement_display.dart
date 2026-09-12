import 'package:flutter/material.dart';
import '../../data/models/achievement.dart';
import '../../data/repositories/achievement_repository.dart';
import '../screens/achievement_detail_view.dart';

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

/// アチーブメントバッジ表示
class AchievementBadgeWidget extends StatelessWidget {
  final AchievementBadge badge;
  final bool showProgress;

  const AchievementBadgeWidget({
    super.key,
    required this.badge,
    this.showProgress = false,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: badge.unlocked ? Colors.amber[100] : Colors.grey[300],
            border: Border.all(
              color: badge.unlocked ? Colors.amber : Colors.grey,
              width: 2,
            ),
            boxShadow: badge.unlocked
                ? [
                    BoxShadow(
                      color: Colors.amber.withValues(alpha: 0.5),
                      blurRadius: 8,
                      spreadRadius: 2,
                    ),
                  ]
                : null,
          ),
          child: Center(
            child: Text(
              badge.icon,
              style: const TextStyle(fontSize: 40),
            ),
          ),
        ),
        const SizedBox(height: 8),
        Text(
          badge.name,
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 12,
            color: badge.unlocked ? Colors.black : Colors.grey[600],
          ),
          textAlign: TextAlign.center,
        ),
        if (showProgress && !badge.unlocked)
          Column(
            children: [
              const SizedBox(height: 4),
              SizedBox(
                width: 60,
                child: LinearProgressIndicator(value: badge.progress),
              ),
              const SizedBox(height: 2),
              Text(
                '${(badge.progress * 100).toStringAsFixed(0)}%',
                style: const TextStyle(fontSize: 10, color: Colors.grey),
              ),
            ],
          ),
        if (badge.unlocked)
          Column(
            children: [
              const SizedBox(height: 4),
              Text(
                '+${badge.points}pt',
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.bold,
                  color: Colors.amber,
                ),
              ),
            ],
          ),
      ],
    );
  }
}

/// アチーブメント一覧表示
class AchievementListWidget extends StatefulWidget {
  final List<AchievementProgress> progresses;
  final bool showLocked;

  const AchievementListWidget({
    super.key,
    required this.progresses,
    this.showLocked = true,
  });

  @override
  State<AchievementListWidget> createState() => _AchievementListWidgetState();
}

class _AchievementListWidgetState extends State<AchievementListWidget> {
  final _achievementRepo = AchievementRepository();
  AchievementCategory? _selectedCategory;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Map<String, Achievement>>(
      future: _achievementRepo.getAllAchievements(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return const Center(child: CircularProgressIndicator());
        }

        final achievements = snapshot.data!;
        final progressMap = {
          for (final p in widget.progresses) p.achievementId: p
        };

        // フィルタリング
        var filtered = achievements.values.toList();
        if (_selectedCategory != null) {
          filtered = filtered
              .where((a) => a.category == _selectedCategory)
              .toList();
        }
        if (!widget.showLocked) {
          filtered = filtered
              .where((a) => progressMap[a.id]?.unlocked ?? false)
              .toList();
        }

        return Column(
          children: [
            // カテゴリフィルタ
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 12),
              child: Row(
                children: [
                  FilterChip(
                    label: const Text('すべて'),
                    selected: _selectedCategory == null,
                    onSelected: (selected) {
                      setState(() => _selectedCategory = null);
                    },
                  ),
                  const SizedBox(width: 8),
                  for (final category in AchievementCategory.values)
                    Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: FilterChip(
                        label: Text(category.displayName),
                        selected: _selectedCategory == category,
                        onSelected: (selected) {
                          setState(() =>
                              _selectedCategory = selected ? category : null);
                        },
                      ),
                    ),
                ],
              ),
            ),

            // アチーブメント一覧
            Expanded(
              child: GridView.builder(
                padding: const EdgeInsets.all(12),
                gridDelegate: const SliverGridDelegateWithMaxCrossAxisExtent(
                  maxCrossAxisExtent: 100,
                  crossAxisSpacing: 16,
                  mainAxisSpacing: 24,
                ),
                itemCount: filtered.length,
                itemBuilder: (context, index) {
                  final achievement = filtered[index];
                  final progress = progressMap[achievement.id];
                  final badge = AchievementBadge(
                    achievementId: achievement.id,
                    name: achievement.name,
                    icon: achievement.icon,
                    points: achievement.points,
                    unlocked: progress?.unlocked ?? false,
                    unlockedAt: progress?.unlockedAt,
                    progress: progress?.progressPercent ?? 0.0,
                  );

                  return GestureDetector(
                    onTap: () => _showAchievementDetails(context, achievement, progress),
                    child: AchievementBadgeWidget(
                      badge: badge,
                      showProgress: true,
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  void _showAchievementDetails(
    BuildContext context,
    Achievement achievement,
    AchievementProgress? progress,
  ) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Row(
          children: [
            Text(achievement.icon, style: const TextStyle(fontSize: 28)),
            const SizedBox(width: 12),
            Expanded(child: Text(achievement.name)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              achievement.description,
              style: const TextStyle(fontSize: 14),
            ),
            const SizedBox(height: 16),
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.blue[50],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Column(
                    children: [
                      Text(
                        'カテゴリ',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '${achievement.category.icon} ${achievement.category.displayName}',
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ],
                  ),
                  Column(
                    children: [
                      Text(
                        'ポイント',
                        style: Theme.of(context).textTheme.labelSmall,
                      ),
                      const SizedBox(height: 4),
                      Text(
                        '+${achievement.points}pt',
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          color: Colors.amber,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            if (progress != null) ...[
              const SizedBox(height: 16),
              if (progress.unlocked)
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.green[50],
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    children: [
                      const Icon(Icons.check_circle, color: Colors.green),
                      const SizedBox(width: 8),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text('獲得済み', style: TextStyle(fontWeight: FontWeight.bold)),
                          Text(
                            progress.unlockedAt != null
                                ? '${progress.unlockedAt!.year}年${progress.unlockedAt!.month}月${progress.unlockedAt!.day}日'
                                : '',
                            style: const TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ],
                      ),
                    ],
                  ),
                )
              else
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '進捗',
                      style: Theme.of(context).textTheme.labelSmall,
                    ),
                    const SizedBox(height: 8),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(4),
                      child: LinearProgressIndicator(
                        value: progress.progressPercent,
                        minHeight: 8,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      '${(progress.progressPercent * 100).toStringAsFixed(0)}%',
                      style: const TextStyle(fontSize: 12, color: Colors.grey),
                    ),
                  ],
                ),
            ],
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('閉じる'),
          ),
        ],
      ),
    );
  }
}
