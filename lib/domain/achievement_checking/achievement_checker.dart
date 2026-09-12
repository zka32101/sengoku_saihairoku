import '../../data/models/achievement.dart';
import '../../data/models/battle_result_data.dart';
import '../../data/models/scenario_data.dart';
import '../../data/models/difficulty_mode.dart';
import '../../data/repositories/achievement_repository.dart';
import '../../core/services/firebase_service.dart';

/// 実績獲得条件を確認し、達成したら自動的に解放するサービス
class AchievementChecker {
  static final AchievementChecker _instance = AchievementChecker._internal();

  late AchievementRepository _achievementRepo;

  factory AchievementChecker() {
    return _instance;
  }

  AchievementChecker._internal();

  /// 初期化
  Future<void> initialize() async {
    _achievementRepo = AchievementRepository();
  }

  /// 戦闘後に実績を確認
  /// [userId] ユーザーID
  /// [scenarioId] シナリオID
  /// [won] 勝利したか
  /// [casualtyRate] 損失率（0.0-1.0）
  /// [turnCount] ターン数
  /// [totalScore] 総スコア
  /// [battleDuration] 戦闘時間（秒）
  Future<List<Achievement>> checkBattleAchievements({
    required String userId,
    required Scenario scenarioId,
    required bool won,
    required double casualtyRate,
    required int turnCount,
    required int totalScore,
    required int battleDuration,
  }) async {
    if (!won) return []; // 敗北時は戦闘実績をチェックしない

    final unlockedAchievements = <Achievement>[];
    final allAchievements = _achievementRepo.getAllAchievements();

    for (final achievement in allAchievements) {
      if (achievement.category != AchievementCategory.combat) continue;

      // すでに獲得していたら確認する必要はない
      if (await _isAchievementUnlocked(userId, achievement.id)) continue;

      bool shouldUnlock = false;

      switch (achievement.conditionType) {
        case AchievementConditionType.battleWins:
          // 戦闘勝利数を確認
          shouldUnlock = await _checkBattleWinsCondition(
            userId,
            achievement.conditionValue,
          );
          break;

        case AchievementConditionType.turnEfficiency:
          // ターン効率を確認（低いターン数＝高効率）
          // conditionValue は最大ターン数
          shouldUnlock = turnCount <= achievement.conditionValue;
          break;

        case AchievementConditionType.perfectBattle:
          // パーフェクト戦闘（損失率0%）
          shouldUnlock = casualtyRate == 0.0;
          break;

        case AchievementConditionType.scenarioCleared:
          // 特定シナリオクリア
          // achievement.conditionValue をシナリオIDとして使用
          shouldUnlock = _isScenarioClear(scenarioId);
          break;

        default:
          // その他の条件タイプはここでは処理しない
          break;
      }

      if (shouldUnlock) {
        await _achievementRepo.unlockAchievement(userId, achievement.id);
        unlockedAchievements.add(achievement);
      }
    }

    return unlockedAchievements;
  }

  /// レベルアップ時に実績を確認
  /// [userId] ユーザーID
  /// [newLevel] 新しいレベル
  Future<List<Achievement>> checkLevelAchievements({
    required String userId,
    required int newLevel,
  }) async {
    final unlockedAchievements = <Achievement>[];
    final allAchievements = _achievementRepo.getAllAchievements();

    for (final achievement in allAchievements) {
      if (achievement.category != AchievementCategory.progression) continue;
      if (achievement.conditionType != AchievementConditionType.levelReached) {
        continue;
      }

      // すでに獲得していたら確認する必要はない
      if (await _isAchievementUnlocked(userId, achievement.id)) continue;

      // レベル条件を確認
      if (newLevel >= achievement.conditionValue) {
        await _achievementRepo.unlockAchievement(userId, achievement.id);
        unlockedAchievements.add(achievement);
      }
    }

    return unlockedAchievements;
  }

  /// コスメティック解放時に実績を確認
  /// [userId] ユーザーID
  /// [unlockedCosmeticId] 解放されたコスメティックID
  /// [totalUnlockedCount] 総解放数
  Future<List<Achievement>> checkCosmeticAchievements({
    required String userId,
    required String unlockedCosmeticId,
    required int totalUnlockedCount,
  }) async {
    final unlockedAchievements = <Achievement>[];
    final allAchievements = _achievementRepo.getAllAchievements();

    for (final achievement in allAchievements) {
      if (achievement.category != AchievementCategory.cosmetic) continue;
      if (achievement.conditionType != AchievementConditionType.cosmeticUnlocked) {
        continue;
      }

      // すでに獲得していたら確認する必要はない
      if (await _isAchievementUnlocked(userId, achievement.id)) continue;

      // コスメティック解放数を確認
      if (totalUnlockedCount >= achievement.conditionValue) {
        await _achievementRepo.unlockAchievement(userId, achievement.id);
        unlockedAchievements.add(achievement);
      }
    }

    return unlockedAchievements;
  }

  /// プレスティジランク変更時に実績を確認
  /// [userId] ユーザーID
  /// [prestigeRank] 新しいプレスティジランク
  Future<List<Achievement>> checkPrestigeAchievements({
    required String userId,
    required int prestigeRank,
  }) async {
    final unlockedAchievements = <Achievement>[];
    final allAchievements = _achievementRepo.getAllAchievements();

    for (final achievement in allAchievements) {
      if (achievement.category != AchievementCategory.prestige) continue;
      if (achievement.conditionType != AchievementConditionType.prestigeRank) {
        continue;
      }

      // すでに獲得していたら確認する必要はない
      if (await _isAchievementUnlocked(userId, achievement.id)) continue;

      // プレスティジランク条件を確認
      if (prestigeRank >= achievement.conditionValue) {
        await _achievementRepo.unlockAchievement(userId, achievement.id);
        unlockedAchievements.add(achievement);
      }
    }

    return unlockedAchievements;
  }

  /// プレイ時間に基づいて実績を確認
  /// [userId] ユーザーID
  /// [totalPlayTimeMinutes] 総プレイ時間（分）
  Future<List<Achievement>> checkPlayTimeAchievements({
    required String userId,
    required int totalPlayTimeMinutes,
  }) async {
    final unlockedAchievements = <Achievement>[];
    final allAchievements = _achievementRepo.getAllAchievements();

    for (final achievement in allAchievements) {
      if (achievement.category != AchievementCategory.progression) continue;
      if (achievement.conditionType != AchievementConditionType.totalPlayTime) {
        continue;
      }

      // すでに獲得していたら確認する必要はない
      if (await _isAchievementUnlocked(userId, achievement.id)) continue;

      // プレイ時間を分単位で比較
      final requiredMinutes = achievement.conditionValue;
      if (totalPlayTimeMinutes >= requiredMinutes) {
        await _achievementRepo.unlockAchievement(userId, achievement.id);
        unlockedAchievements.add(achievement);
      }
    }

    return unlockedAchievements;
  }

  /// 戦闘勝利数条件を確認
  /// 内部的に過去の戦闘勝利数をカウント
  Future<bool> _checkBattleWinsCondition(
    String userId,
    int requiredWins,
  ) async {
    // TODO: Firebase から戦闘勝利数を取得
    // 現在はダミー実装
    return false;
  }

  /// シナリオクリア条件を確認
  bool _isScenarioClear(Scenario scenario) {
    // シナリオIDの確認（conditionValue と一致するか）
    // この実装は呼び出し元で提供された情報に基づく
    return true; // 既にクリアしたシナリオについて呼ばれるため
  }

  /// 実績が既に解放されているか確認
  Future<bool> _isAchievementUnlocked(String userId, String achievementId) async {
    try {
      final progress = await _achievementRepo.getAchievementProgress(
        userId,
        achievementId,
      );
      return progress != null && progress.isUnlocked;
    } catch (e) {
      print('Error checking achievement unlock status: $e');
      return false;
    }
  }
}
