import 'package:cloud_firestore/cloud_firestore.dart';

/// 初回起動オンボーディング（導入チュートリアル）の完了状態を管理する。
class OnboardingRepository {
  static final OnboardingRepository _instance =
      OnboardingRepository._internal();
  factory OnboardingRepository() => _instance;
  OnboardingRepository._internal();

  /// 未完了なら true（＝オンボーディングを表示すべき）。
  /// 判定できない場合は安全側に倒して true を返す（最悪もう一度表示されるだけ）。
  Future<bool> needsOnboarding(String? userId) async {
    if (userId == null) return true;

    try {
      final doc =
          await FirebaseFirestore.instance.collection('users').doc(userId).get();
      final completed =
          (doc.data() as Map<String, dynamic>?)?['onboardingCompleted'] as bool?;
      return completed != true;
    } catch (e) {
      print('Error checking onboarding status: $e');
      return true;
    }
  }

  Future<void> markCompleted(String userId) async {
    try {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(userId)
          .set({'onboardingCompleted': true}, SetOptions(merge: true));
    } catch (e) {
      print('Error marking onboarding completed: $e');
    }
  }
}
