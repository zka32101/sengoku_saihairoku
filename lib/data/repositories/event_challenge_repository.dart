import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/event_challenge.dart';

/// 期間限定イベントチャレンジ管理リポジトリ
///
/// Firestoreの`events`コレクションで配信される特別チャレンジを取得し、
/// ユーザーごとの達成状態を`users/{uid}/event_progress/{eventId}`に保存する。
class EventChallengeRepository {
  static final EventChallengeRepository _instance =
      EventChallengeRepository._internal();
  factory EventChallengeRepository() => _instance;
  EventChallengeRepository._internal();

  CollectionReference get _eventsRef =>
      FirebaseFirestore.instance.collection('events');

  CollectionReference _progressRef(String userId) => FirebaseFirestore
      .instance
      .collection('users')
      .doc(userId)
      .collection('event_progress');

  /// 現在有効なイベントチャレンジを1件取得（複数ある場合は終了が近い順の先頭）
  Future<EventChallenge?> getActiveEvent() async {
    try {
      final now = Timestamp.now();
      final snapshot = await _eventsRef
          .where('startAt', isLessThanOrEqualTo: now)
          .orderBy('startAt', descending: true)
          .limit(10)
          .get();

      final candidates = snapshot.docs
          .map((doc) => EventChallenge.fromFirestore(doc))
          .where((event) => event.isActive)
          .toList()
        ..sort((a, b) => a.endAt.compareTo(b.endAt));

      return candidates.isEmpty ? null : candidates.first;
    } catch (e) {
      print('Error fetching active event: $e');
      return null;
    }
  }

  /// 指定イベントのユーザー進捗を取得
  Future<EventChallengeProgress?> getProgress(
      String userId, String eventId) async {
    try {
      final doc = await _progressRef(userId).doc(eventId).get();
      if (!doc.exists) return null;
      return EventChallengeProgress.fromJson(
          doc.data() as Map<String, dynamic>);
    } catch (e) {
      print('Error fetching event progress: $e');
      return null;
    }
  }

  /// イベントチャレンジ達成を記録
  Future<void> completeEvent(String userId, String eventId) async {
    final progress = EventChallengeProgress(
      eventId: eventId,
      completedAt: DateTime.now(),
      claimed: false,
    );
    await _progressRef(userId).doc(eventId).set(progress.toJson());
  }

  /// イベント報酬受け取りを記録
  Future<void> claimReward(String userId, String eventId) async {
    await _progressRef(userId).doc(eventId).update({'claimed': true});
  }
}
