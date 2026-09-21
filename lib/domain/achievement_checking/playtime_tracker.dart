import '../../core/services/firebase_service.dart';
import 'achievement_checker.dart';

/// ユーザーのプレイ時間を追跡し、時間ベースの実績をチェックするサービス
class PlaytimeTracker {
  static final PlaytimeTracker _instance = PlaytimeTracker._internal();

  late FirebaseService _firebaseService;
  late AchievementChecker _achievementChecker;

  factory PlaytimeTracker() {
    return _instance;
  }

  PlaytimeTracker._internal();

  /// 初期化
  Future<void> initialize() async {
    _firebaseService = FirebaseService();
    _achievementChecker = AchievementChecker();
  }

  /// 戦闘後にプレイ時間を記録し、関連実績をチェック
  /// [userId] ユーザーID
  /// [battleDurationSeconds] 戦闘時間（秒）
  Future<void> recordBattlePlaytime(
    String userId,
    int battleDurationSeconds,
  ) async {
    try {
      // プレイ時間を記録（実装は別のメソッドで）
      await _addPlaytime(userId, battleDurationSeconds);
      
      // プレイ時間ベースの実績をチェック
      final totalPlaytimeMinutes = await _getTotalPlaytimeMinutes(userId);
      await _achievementChecker.checkPlayTimeAchievements(
        userId: userId,
        totalPlayTimeMinutes: totalPlaytimeMinutes,
      );
    } catch (e) {
      print('Error recording playtime: $e');
    }
  }

  /// プレイ時間を追加
  Future<void> _addPlaytime(String userId, int durationSeconds) async {
    // TODO: Firestore に playtime_records を記録
    // スキーマ: users/{userId}/playtime_records/{recordId}
    // フィールド: battleDate, durationSeconds, elapsedAt
  }

  /// 総プレイ時間を取得
  Future<int> _getTotalPlaytimeMinutes(String userId) async {
    try {
      // TODO: Firestore から playtime_records を集計
      // return sum(durationSeconds) / 60
      return 0; // ダミー
    } catch (e) {
      print('Error getting total playtime: $e');
      return 0;
    }
  }
}
