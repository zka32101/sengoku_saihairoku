import 'dart:convert';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/services.dart';
import '../models/battle_pass.dart';

/// バトルパスデータを管理するリポジトリ
class BattlePassRepository {
  static final BattlePassRepository _instance = BattlePassRepository._internal();

  late BattlePass _currentBattlePass;
  bool _initialized = false;

  factory BattlePassRepository() {
    return _instance;
  }

  BattlePassRepository._internal();

  /// 初期化（JSONアセットからバトルパス定義を読み込む）
  Future<void> initialize() async {
    if (_initialized) return;

    try {
      final jsonString = await rootBundle.loadString('assets/data/battle_passes.json');
      final jsonData = jsonDecode(jsonString) as Map<String, dynamic>;
      final currentData = jsonData['current'] as Map<String, dynamic>;
      _currentBattlePass = BattlePass.fromJson(currentData);
      _initialized = true;
      print('✅ BattlePass Repository initialized');
    } catch (e) {
      print('❌ Error initializing BattlePass Repository: $e');
      rethrow;
    }
  }

  /// 現在のシーズンのバトルパスを取得
  BattlePass getCurrentBattlePass() {
    if (!_initialized) {
      throw StateError('BattlePassRepository not initialized');
    }
    return _currentBattlePass;
  }

  /// ユーザーのバトルパス進捗を取得
  Future<BattlePassProgress?> getUserBattlePassProgress(String userId) async {
    try {
      final doc = await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('battle_pass')
          .doc(_currentBattlePass.id)
          .get();

      if (!doc.exists) {
        return null;
      }

      return BattlePassProgress.fromFirestore(doc);
    } catch (e) {
      print('Error getting battle pass progress: $e');
      return null;
    }
  }

  /// ユーザーのバトルパス進捗を初期化（新しいユーザーまたは新シーズン）
  Future<BattlePassProgress> initializeBattlePassProgress(
    String userId, {
    bool hasPremium = false,
  }) async {
    try {
      final now = DateTime.now();
      final progress = BattlePassProgress(
        userId: userId,
        battlePassId: _currentBattlePass.id,
        currentTier: 1,
        currentXp: 0,
        totalXp: 0,
        unlockedRewards: [],
        hasPremium: hasPremium,
        createdAt: now,
        updatedAt: now,
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('battle_pass')
          .doc(_currentBattlePass.id)
          .set(progress.toFirestore());

      return progress;
    } catch (e) {
      print('Error initializing battle pass progress: $e');
      rethrow;
    }
  }

  /// XPを獲得してバトルパス進捗を更新
  Future<BattlePassProgress?> gainXp(
    String userId,
    int xpAmount,
  ) async {
    try {
      var progress = await getUserBattlePassProgress(userId);
      if (progress == null) {
        progress = await initializeBattlePassProgress(userId);
      }

      // 新しいXPを追加
      int newCurrentXp = progress.currentXp + xpAmount;
      int newTotalXp = progress.totalXp + xpAmount;
      int newTier = progress.currentTier;
      List<String> newUnlockedRewards = List.from(progress.unlockedRewards);

      // ティアアップの判定
      while (newTier < _currentBattlePass.maxTier) {
        final currentTierData = _currentBattlePass.tiers[newTier - 1];

        if (newCurrentXp >= currentTierData.xpRequired) {
          // ティアアップ
          newCurrentXp -= currentTierData.xpRequired;
          newTier++;

          // 報酬をアンロック
          final nextTierData = _currentBattlePass.tiers[newTier - 1];
          if (!newUnlockedRewards.contains(nextTierData.rewardId)) {
            newUnlockedRewards.add(nextTierData.rewardId);
          }

          // フリートラックの報酬もアンロック
          if (nextTierData.track == BattlePassTrack.free &&
              !newUnlockedRewards.contains(nextTierData.rewardId)) {
            newUnlockedRewards.add(nextTierData.rewardId);
          }
        } else {
          break;
        }
      }

      // 最大ティアに達したか確認
      if (newTier > _currentBattlePass.maxTier) {
        newTier = _currentBattlePass.maxTier;
        newCurrentXp = 0;
      }

      // 更新されたプログレスを作成
      final updatedProgress = BattlePassProgress(
        userId: userId,
        battlePassId: _currentBattlePass.id,
        currentTier: newTier,
        currentXp: newCurrentXp,
        totalXp: newTotalXp,
        unlockedRewards: newUnlockedRewards,
        hasPremium: progress.hasPremium,
        createdAt: progress.createdAt,
        updatedAt: DateTime.now(),
      );

      // Firestoreに保存
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('battle_pass')
          .doc(_currentBattlePass.id)
          .set(updatedProgress.toFirestore());

      return updatedProgress;
    } catch (e) {
      print('Error gaining XP: $e');
      return null;
    }
  }

  /// プレミアムアクティベーション
  Future<BattlePassProgress?> activatePremium(String userId) async {
    try {
      var progress = await getUserBattlePassProgress(userId);
      if (progress == null) {
        return await initializeBattlePassProgress(userId, hasPremium: true);
      }

      // すでにプレミアムの場合は何もしない
      if (progress.hasPremium) {
        return progress;
      }

      // プレミアム報酬をアンロック
      List<String> newUnlockedRewards = List.from(progress.unlockedRewards);

      // プレミアムトラックの報酬をアンロック（現在のティアまで）
      for (int i = 1; i <= progress.currentTier; i++) {
        final tierData = _currentBattlePass.tiers[i - 1];
        if (tierData.track == BattlePassTrack.premium &&
            !newUnlockedRewards.contains(tierData.rewardId)) {
          newUnlockedRewards.add(tierData.rewardId);
        }
      }

      final updatedProgress = BattlePassProgress(
        userId: userId,
        battlePassId: _currentBattlePass.id,
        currentTier: progress.currentTier,
        currentXp: progress.currentXp,
        totalXp: progress.totalXp,
        unlockedRewards: newUnlockedRewards,
        hasPremium: true,
        createdAt: progress.createdAt,
        updatedAt: DateTime.now(),
      );

      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .collection('battle_pass')
          .doc(_currentBattlePass.id)
          .set(updatedProgress.toFirestore());

      return updatedProgress;
    } catch (e) {
      print('Error activating premium: $e');
      return null;
    }
  }

  /// 特定のティアのデータを取得
  BattlePassTier? getTierData(int tierNumber) {
    if (tierNumber < 1 || tierNumber > _currentBattlePass.tiers.length) {
      return null;
    }
    return _currentBattlePass.tiers[tierNumber - 1];
  }

  /// ユーザーの次のティアまでのXPを計算
  int getXpUntilNextTier(BattlePassProgress progress) {
    if (progress.currentTier >= _currentBattlePass.maxTier) {
      return 0;
    }

    final currentTierData = _currentBattlePass.tiers[progress.currentTier - 1];
    return (currentTierData.xpRequired - progress.currentXp).clamp(0, currentTierData.xpRequired);
  }

  /// 現在のティアの進捗率を計算（0.0 - 1.0）
  double getProgressPercent(BattlePassProgress progress) {
    if (progress.currentTier >= _currentBattlePass.maxTier) {
      return 1.0;
    }

    final currentTierData = _currentBattlePass.tiers[progress.currentTier - 1];
    return (progress.currentXp / currentTierData.xpRequired).clamp(0.0, 1.0);
  }

  /// シーズン残り日数を計算
  int getDaysRemaining() {
    final now = DateTime.now();
    final remaining = _currentBattlePass.endDate.difference(now).inDays;
    return remaining.clamp(0, remaining);
  }

  /// バトルパス統計情報を取得
  Future<BattlePassStats?> getBattlePassStats(String userId) async {
    try {
      final progress = await getUserBattlePassProgress(userId);
      if (progress == null) {
        return null;
      }

      final totalRewards = progress.unlockedRewards.length;
      final premiumRewards = progress.unlockedRewards
          .where((rewardId) => _isRewardPremium(rewardId))
          .length;

      return BattlePassStats(
        currentTier: progress.currentTier,
        progressPercent: getProgressPercent(progress),
        totalRewardsEarned: totalRewards,
        premiumRewardsEarned: premiumRewards,
        seasonEndDate: _currentBattlePass.endDate,
        daysRemaining: getDaysRemaining(),
      );
    } catch (e) {
      print('Error getting battle pass stats: $e');
      return null;
    }
  }

  /// 報酬がプレミアムかどうかを判定
  bool _isRewardPremium(String rewardId) {
    return rewardId.contains('premium') || rewardId.contains('exclusive');
  }
}
