import '../../data/models/achievement.dart';
import '../../data/repositories/battle_stats_repository.dart';
import 'achievement_checker.dart';
import 'package:flutter/foundation.dart';

/// ユーザーのプレイ時間を追跡し、時間ベースの実績をチェックするサービス
class PlaytimeTracker {
  static final PlaytimeTracker _instance = PlaytimeTracker._internal();

  late AchievementChecker _achievementChecker;
  final _battleStatsRepo = BattleStatsRepository();

  factory PlaytimeTracker() {
    return _instance;
  }

  PlaytimeTracker._internal();

  /// 初期化
  Future<void> initialize() async {
    _achievementChecker = AchievementChecker();
  }

  /// 戦闘後にプレイ時間を記録し、関連実績をチェックする。
  /// [userId] ユーザーID
  /// [battleDurationSeconds] 戦闘時間（秒）
  /// 戻り値は、今回新たに解放された実績の一覧。
  Future<List<Achievement>> recordBattlePlaytime(
    String userId,
    int battleDurationSeconds,
  ) async {
    try {
      await _battleStatsRepo.addPlaytimeSeconds(battleDurationSeconds);

      final totalPlaytimeMinutes = await _battleStatsRepo
          .getTotalPlaytimeMinutes();
      return await _achievementChecker.checkPlayTimeAchievements(
        userId: userId,
        totalPlayTimeMinutes: totalPlaytimeMinutes,
      );
    } catch (e) {
      debugPrint('Error recording playtime: $e');
      return [];
    }
  }
}
