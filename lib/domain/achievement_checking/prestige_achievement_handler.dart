import '../../data/models/achievement.dart';
import 'achievement_checker.dart';

/// プレスティジシステムと連携して実績チェックを行うサービス
class PrestigeAchievementHandler {
  static final PrestigeAchievementHandler _instance =
      PrestigeAchievementHandler._internal();

  late AchievementChecker _achievementChecker;

  factory PrestigeAchievementHandler() {
    return _instance;
  }

  PrestigeAchievementHandler._internal();

  /// 初期化
  Future<void> initialize() async {
    _achievementChecker = AchievementChecker();
  }

  /// プレスティジランク上昇時に実績をチェック
  /// [userId] ユーザーID
  /// [newPrestigeRank] 新しいプレスティジランク（ブロンズ=1, シルバー=2, ゴールド=3）
  Future<List<Achievement>> checkPrestigeRankUp(
    String userId,
    int newPrestigeRank,
  ) async {
    try {
      return await _achievementChecker.checkPrestigeAchievements(
        userId: userId,
        prestigeRank: newPrestigeRank,
      );
    } catch (e) {
      print('Error checking prestige achievements: $e');
      return [];
    }
  }

  /// プレスティジリセット時の特殊実績チェック
  /// プレスティジリセットのたびに解放される実績（例: "Press to Reset"）
  Future<List<Achievement>> checkPrestigeResetAchievements(
    String userId,
    int resetCount,
  ) async {
    try {
      // TODO: プレスティジリセット回数に基づいた実績チェック
      return [];
    } catch (e) {
      print('Error checking prestige reset achievements: $e');
      return [];
    }
  }
}
