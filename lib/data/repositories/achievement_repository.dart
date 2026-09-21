import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import 'dart:convert';
import '../models/achievement.dart';

/// 実績データリポジトリ
class AchievementRepository {
  static AchievementRepository? _instance;
  
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  late Map<String, Achievement> _achievementsCache;
  bool _initialized = false;

  AchievementRepository._();

  factory AchievementRepository() {
    _instance ??= AchievementRepository._();
    return _instance!;
  }

  /// 初期化: achievements.json を読み込む
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      final String jsonString = await rootBundle.loadString('assets/data/achievements.json');
      final Map<String, dynamic> jsonData = json.decode(jsonString);
      
      _achievementsCache = {};
      if (jsonData['achievements'] is List) {
        for (var item in jsonData['achievements']) {
          final achievement = Achievement.fromJson(item);
          _achievementsCache[achievement.id] = achievement;
        }
      }
      
      _initialized = true;
    } catch (e) {
      print('Error initializing achievements: $e');
      _achievementsCache = {};
      _initialized = true;
    }
  }

  /// すべての実績を取得
  List<Achievement> getAllAchievements() {
    return _achievementsCache.values.toList();
  }

  /// 実績 ID から実績を取得
  Achievement? getAchievementById(String achievementId) {
    return _achievementsCache[achievementId];
  }

  /// カテゴリーで実績をフィルタリング
  List<Achievement> getAchievementsByCategory(AchievementCategory category) {
    return _achievementsCache.values
        .where((a) => a.category == category)
        .toList();
  }

  /// ユーザーのすべての実績進捗を取得
  Future<List<AchievementProgress>> getUserAchievements(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('achievements')
          .get();

      return snapshot.docs
          .map((doc) => AchievementProgress.fromFirestore(doc))
          .toList();
    } catch (e) {
      print('Error getting user achievements: $e');
      return [];
    }
  }

  /// ユーザーの実績進捗を取得（実績 ID で）
  Future<AchievementProgress?> getAchievementProgress(
    String userId,
    String achievementId,
  ) async {
    try {
      final doc = await _firestore
          .collection('users')
          .doc(userId)
          .collection('achievements')
          .doc(achievementId)
          .get();

      if (!doc.exists) return null;
      return AchievementProgress.fromFirestore(doc);
    } catch (e) {
      print('Error getting achievement progress: $e');
      return null;
    }
  }

  /// 実績をアンロック
  Future<void> unlockAchievement(
    String userId,
    String achievementId,
  ) async {
    try {
      final now = DateTime.now();
      
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('achievements')
          .doc(achievementId)
          .set({
        'userId': userId,
        'achievementId': achievementId,
        'isUnlocked': true,
        'unlockedAt': Timestamp.fromDate(now),
        'progress': 100,
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
      });
    } catch (e) {
      print('Error unlocking achievement: $e');
      rethrow;
    }
  }

  /// 実績の進捗を更新
  Future<void> updateAchievementProgress(
    String userId,
    String achievementId,
    int progress,
  ) async {
    try {
      final now = DateTime.now();
      final achievement = getAchievementById(achievementId);
      
      // 進捗が 100% になったらアンロック
      final isUnlocked = progress >= 100;
      
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('achievements')
          .doc(achievementId)
          .set({
        'userId': userId,
        'achievementId': achievementId,
        'isUnlocked': isUnlocked,
        'unlockedAt': isUnlocked ? Timestamp.fromDate(now) : null,
        'progress': progress,
        'createdAt': Timestamp.fromDate(now),
        'updatedAt': Timestamp.fromDate(now),
      }, SetOptions(merge: true));
    } catch (e) {
      print('Error updating achievement progress: $e');
      rethrow;
    }
  }

  /// ユーザーの実績統計を計算
  Future<AchievementStats> getAchievementStats(String userId) async {
    try {
      final achievements = await getUserAchievements(userId);
      final allAchievements = getAllAchievements();
      
      int unlockedCount = 0;
      int totalPoints = 0;
      final categoryProgress = <AchievementCategory, int>{};
      DateTime? lastUnlockedAt;

      for (final ach in allAchievements) {
        final progress = achievements.firstWhere(
          (p) => p.achievementId == ach.id,
          orElse: () => AchievementProgress(
            userId: userId,
            achievementId: ach.id,
            isUnlocked: false,
            progress: 0,
            createdAt: DateTime.now(),
            updatedAt: DateTime.now(),
          ),
        );

        if (progress.isUnlocked) {
          unlockedCount++;
          totalPoints += ach.points ?? 0;
          
          if (lastUnlockedAt == null ||
              (progress.unlockedAt != null &&
                  progress.unlockedAt!.isAfter(lastUnlockedAt))) {
            lastUnlockedAt = progress.unlockedAt;
          }
        }

        // カテゴリー進捗を集計
        categoryProgress[ach.category] =
            (categoryProgress[ach.category] ?? 0) +
                (progress.isUnlocked ? 1 : 0);
      }

      final unlockedPercentage = allAchievements.isEmpty
          ? 0.0
          : (unlockedCount / allAchievements.length) * 100;

      return AchievementStats(
        totalAchievements: allAchievements.length,
        unlockedCount: unlockedCount,
        unlockedPercentage: unlockedPercentage,
        totalPoints: totalPoints,
        categoryProgress: categoryProgress,
        lastUnlockedAt: lastUnlockedAt ?? DateTime.now(),
      );
    } catch (e) {
      print('Error getting achievement stats: $e');
      rethrow;
    }
  }

  /// 実績履歴を取得
  Future<List<Map<String, dynamic>>> getAchievementHistory(
    String userId, {
    int limit = 20,
  }) async {
    try {
      final achievements = await getUserAchievements(userId);
      
      final history = achievements
          .where((a) => a.isUnlocked && a.unlockedAt != null)
          .toList()
          ..sort((a, b) => b.unlockedAt!.compareTo(a.unlockedAt!));

      return history.take(limit).map((p) {
        final achievement = getAchievementById(p.achievementId);
        return {
          'achievement': achievement,
          'unlockedAt': p.unlockedAt,
        };
      }).toList();
    } catch (e) {
      print('Error getting achievement history: $e');
      return [];
    }
  }
}
