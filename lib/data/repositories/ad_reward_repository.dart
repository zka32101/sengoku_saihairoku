import 'package:cloud_firestore/cloud_firestore.dart';
import 'currency_repository.dart';

/// リワード広告視聴によるゴールド獲得を管理するリポジトリ。
/// 1日あたりの視聴回数に上限を設け、Firestoreで日付ごとにカウントする。
class AdRewardRepository {
  static final AdRewardRepository _instance = AdRewardRepository._internal();
  factory AdRewardRepository() => _instance;
  AdRewardRepository._internal();

  static const int dailyWatchLimit = 3;
  static const int rewardGoldAmount = 100;

  final CurrencyRepository _currencyRepo = CurrencyRepository();

  String _todayKey() {
    final now = DateTime.now();
    final mm = now.month.toString().padLeft(2, '0');
    final dd = now.day.toString().padLeft(2, '0');
    return '${now.year}-$mm-$dd';
  }

  DocumentReference _docRef(String userId) => FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('ad_rewards')
      .doc(_todayKey());

  /// 本日すでに視聴した回数
  Future<int> getTodayWatchCount(String userId) async {
    try {
      final doc = await _docRef(userId).get();
      if (!doc.exists) return 0;
      final data = doc.data() as Map<String, dynamic>;
      return data['count'] as int? ?? 0;
    } catch (e) {
      print('Error getting ad reward count: $e');
      return 0;
    }
  }

  /// 本日まだ視聴可能か（上限未満）
  Future<bool> canWatchToday(String userId) async {
    final count = await getTodayWatchCount(userId);
    return count < dailyWatchLimit;
  }

  /// 広告視聴完了を記録し、ゴールドを付与する。
  /// 上限に達していた場合は付与せず false を返す。
  Future<bool> recordWatchAndReward(String userId) async {
    try {
      final docRef = _docRef(userId);
      final granted = await FirebaseFirestore.instance.runTransaction((tx) async {
        final snapshot = await tx.get(docRef);
        final currentCount = snapshot.exists
            ? (snapshot.data() as Map<String, dynamic>)['count'] as int? ?? 0
            : 0;

        if (currentCount >= dailyWatchLimit) return false;

        tx.set(docRef, {
          'count': currentCount + 1,
          'updatedAt': FieldValue.serverTimestamp(),
        });
        return true;
      });

      if (granted) {
        await _currencyRepo.addGold(
          userId,
          rewardGoldAmount,
          source: 'rewarded_ad',
        );
      }
      return granted;
    } catch (e) {
      print('Error recording ad reward: $e');
      return false;
    }
  }
}
