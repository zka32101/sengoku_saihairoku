import 'package:flutter/material.dart';
import '../../data/models/achievement.dart';
import '../../data/repositories/achievement_repository.dart';

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
