import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/achievement.dart';

/// アチーブメント管理リポジトリ
class AchievementRepository {
  static final AchievementRepository _instance =
      AchievementRepository._internal();

  factory AchievementRepository() {
    return _instance;
  }

  AchievementRepository._internal();

  Map<String, dynamic>? _cachedAchievements;

  /// 全アチーブメントを取得
  Future<Map<String, Achievement>> getAllAchievements() async {
    try {
      _cachedAchievements ??= jsonDecode(
        await rootBundle.loadString('assets/data/achievements.json'),
      ) as Map<String, dynamic>;

      final result = <String, Achievement>{};
      for (final entry in _cachedAchievements!.entries) {
        result[entry.key] = Achievement.fromJson(
          entry.value as Map<String, dynamic>,
        );
      }
      return result;
    } catch (e) {
      print('Error loading achievements: $e');
      return {};
    }
  }

  /// IDでアチーブメントを取得
  Future<Achievement?> getAchievementById(String id) async {
    try {
      final all = await getAllAchievements();
      return all[id];
    } catch (e) {
      print('Error getting achievement $id: $e');
      return null;
    }
  }

  /// カテゴリ別のアチーブメントを取得
  Future<List<Achievement>> getByCategory(AchievementCategory category) async {
    try {
      final all = await getAllAchievements();
      return all.values.where((a) => a.category == category).toList();
    } catch (e) {
      print('Error getting achievements by category: $e');
      return [];
    }
  }

  /// 総ポイント数を計算
  Future<int> getTotalPoints(List<AchievementProgress> progresses) async {
    try {
      final achievements = await getAllAchievements();
      var total = 0;
      for (final progress in progresses) {
        if (progress.unlocked) {
          final achievement = achievements[progress.achievementId];
          if (achievement != null) {
            total += achievement.points;
          }
        }
      }
      return total;
    } catch (e) {
      print('Error calculating total points: $e');
      return 0;
    }
  }

  /// アチーブメント統計を取得
  Future<AchievementStats> getStats(List<AchievementProgress> progresses) async {
    try {
      final achievements = await getAllAchievements();
      final byCategory = <AchievementCategory, int>{};
      var totalUnlocked = 0;
      var totalPoints = 0;

      for (final category in AchievementCategory.values) {
        byCategory[category] = 0;
      }

      for (final progress in progresses) {
        final achievement = achievements[progress.achievementId];
        if (achievement != null && progress.unlocked) {
          totalUnlocked++;
          totalPoints += achievement.points;
          byCategory[achievement.category] =
              (byCategory[achievement.category] ?? 0) + 1;
        }
      }

      return AchievementStats(
        totalAchievements: achievements.length,
        unlockedCount: totalUnlocked,
        totalPoints: totalPoints,
        byCategory: byCategory,
        completionPercent: achievements.isNotEmpty
            ? (totalUnlocked / achievements.length * 100).toStringAsFixed(1)
            : '0.0',
      );
    } catch (e) {
      print('Error getting achievement stats: $e');
      return AchievementStats(
        totalAchievements: 0,
        unlockedCount: 0,
        totalPoints: 0,
        byCategory: {},
        completionPercent: '0.0',
      );
    }
  }
}

/// アチーブメント統計
class AchievementStats {
  final int totalAchievements;
  final int unlockedCount;
  final int totalPoints;
  final Map<AchievementCategory, int> byCategory;
  final String completionPercent;

  AchievementStats({
    required this.totalAchievements,
    required this.unlockedCount,
    required this.totalPoints,
    required this.byCategory,
    required this.completionPercent,
  });

  int get lockedCount => totalAchievements - unlockedCount;

  String get summary =>
      '$unlockedCount / $totalAchievements ($completionPercent%)';
}
