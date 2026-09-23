import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/daily_login_bonus.dart';
import 'currency_repository.dart';

/// デイリーログインボーナス管理リポジトリ
///
/// `users/{uid}.dailyLogin`に`{lastClaimedDate, currentStreak}`を保存する。
/// 前日に受け取っていれば連続日数を+1、間隔が空いていれば1にリセットする。
class DailyLoginRepository {
  static final DailyLoginRepository _instance =
      DailyLoginRepository._internal();
  factory DailyLoginRepository() => _instance;
  DailyLoginRepository._internal();

  DocumentReference _userRef(String userId) =>
      FirebaseFirestore.instance.collection('users').doc(userId);

  String _dateKey(DateTime date) =>
      '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';

  /// 現在の状態を取得（受取可能かどうか・連続日数・本日分の報酬額）
  Future<DailyLoginStatus> getStatus(String userId) async {
    final doc = await _userRef(userId).get();
    final data = doc.data() as Map<String, dynamic>?;
    final dailyLogin = data?['dailyLogin'] as Map<String, dynamic>?;

    final lastClaimedDateStr = dailyLogin?['lastClaimedDate'] as String?;
    final storedStreak = dailyLogin?['currentStreak'] as int? ?? 0;

    final today = _dateKey(DateTime.now());
    final yesterday = _dateKey(DateTime.now().subtract(const Duration(days: 1)));

    if (lastClaimedDateStr == today) {
      // 本日すでに受け取り済み
      return DailyLoginStatus(
        currentStreak: storedStreak,
        claimedToday: true,
        todayReward: DailyLoginBonus.goldForStreak(storedStreak),
      );
    }

    // 未受取：連続日数を計算（昨日受け取っていれば継続、それ以外はリセット）
    final nextStreak = lastClaimedDateStr == yesterday ? storedStreak + 1 : 1;

    return DailyLoginStatus(
      currentStreak: nextStreak,
      claimedToday: false,
      todayReward: DailyLoginBonus.goldForStreak(nextStreak),
    );
  }

  /// 本日分のログインボーナスを受け取る（ゴールドを付与し、状態を更新する）
  Future<DailyLoginStatus> claim(String userId) async {
    final status = await getStatus(userId);
    if (status.claimedToday) return status;

    await CurrencyRepository().addGold(
      userId,
      status.todayReward,
      source: 'daily_login_bonus',
    );

    await _userRef(userId).set({
      'dailyLogin': {
        'lastClaimedDate': _dateKey(DateTime.now()),
        'currentStreak': status.currentStreak,
      },
    }, SetOptions(merge: true));

    return DailyLoginStatus(
      currentStreak: status.currentStreak,
      claimedToday: true,
      todayReward: status.todayReward,
    );
  }
}
