import 'package:cloud_firestore/cloud_firestore.dart';

/// フレンド情報
class FriendInfo {
  final String userId;
  final String friendCode;
  final DateTime addedAt;

  const FriendInfo({
    required this.userId,
    required this.friendCode,
    required this.addedAt,
  });

  factory FriendInfo.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return FriendInfo(
      userId: doc.id,
      friendCode: data['friendCode'] as String? ?? '',
      addedAt: (data['addedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
    );
  }
}

/// フレンドコードの発行・フレンド追加・フレンド一覧・
/// フレンド限定ランキングを管理するリポジトリ。
class FriendRepository {
  static final FriendRepository _instance = FriendRepository._internal();
  factory FriendRepository() => _instance;
  FriendRepository._internal();

  final FirebaseFirestore _firestore = FirebaseFirestore.instance;

  /// ユーザーIDから決定的にフレンドコードを生成する（例: userId=abcdef1234... → "ABCDEF12"）
  String codeForUserId(String userId) {
    final cleaned = userId.replaceAll(RegExp(r'[^a-zA-Z0-9]'), '');
    final source = cleaned.length >= 8 ? cleaned.substring(0, 8) : cleaned.padRight(8, '0');
    return source.toUpperCase();
  }

  /// 自分のフレンドコードを取得（未発行なら生成してユーザードキュメントに保存する）
  Future<String> getOrCreateMyFriendCode(String userId) async {
    final code = codeForUserId(userId);

    final userRef = _firestore.collection('users').doc(userId);
    final doc = await userRef.get();
    final data = doc.data();

    if (data == null || data['friendCode'] != code) {
      await userRef.set({'friendCode': code}, SetOptions(merge: true));
      // 逆引き用インデックス（コード→userId）
      await _firestore
          .collection('friend_codes')
          .doc(code)
          .set({'userId': userId});
    }

    return code;
  }

  /// フレンドコードからユーザーIDを解決する
  Future<String?> _resolveUserIdFromCode(String code) async {
    final doc = await _firestore
        .collection('friend_codes')
        .doc(code.toUpperCase().trim())
        .get();
    if (!doc.exists) return null;
    return (doc.data() as Map<String, dynamic>)['userId'] as String?;
  }

  /// フレンドコードを使ってフレンドを追加する（双方向に登録）。
  /// 戻り値：成功したか。コードが無効/自分自身/既に登録済みの場合は false。
  Future<bool> addFriendByCode(String userId, String code) async {
    final friendUserId = await _resolveUserIdFromCode(code);
    if (friendUserId == null || friendUserId == userId) return false;

    final myFriendsRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('friends')
        .doc(friendUserId);

    final existing = await myFriendsRef.get();
    if (existing.exists) return false;

    final now = FieldValue.serverTimestamp();
    final friendCode = codeForUserId(friendUserId);
    final myCode = await getOrCreateMyFriendCode(userId);

    final batch = _firestore.batch();
    batch.set(myFriendsRef, {'friendCode': friendCode, 'addedAt': now});
    batch.set(
      _firestore
          .collection('users')
          .doc(friendUserId)
          .collection('friends')
          .doc(userId),
      {'friendCode': myCode, 'addedAt': now},
    );
    await batch.commit();

    return true;
  }

  Future<void> removeFriend(String userId, String friendUserId) async {
    final batch = _firestore.batch();
    batch.delete(_firestore
        .collection('users')
        .doc(userId)
        .collection('friends')
        .doc(friendUserId));
    batch.delete(_firestore
        .collection('users')
        .doc(friendUserId)
        .collection('friends')
        .doc(userId));
    await batch.commit();
  }

  Future<List<FriendInfo>> getFriends(String userId) async {
    try {
      final snapshot = await _firestore
          .collection('users')
          .doc(userId)
          .collection('friends')
          .orderBy('addedAt', descending: true)
          .get();
      return snapshot.docs.map((d) => FriendInfo.fromFirestore(d)).toList();
    } catch (e) {
      print('Error getting friends: $e');
      return [];
    }
  }

  /// フレンドの合計スコア（rankingsコレクションの score 合計）でランキングを作る。
  /// 自分自身も含める。
  Future<List<FriendRankingEntry>> getFriendsRanking(
    String userId, {
    String? scenarioId,
  }) async {
    try {
      final friends = await getFriends(userId);
      final targetIds = <String>{userId, ...friends.map((f) => f.userId)};
      if (targetIds.isEmpty) return [];

      // Firestoreの whereIn は最大30件まで
      final idList = targetIds.take(30).toList();

      Query query = _firestore
          .collection('rankings')
          .where('userId', whereIn: idList);
      if (scenarioId != null) {
        query = query.where('scenarioId', isEqualTo: scenarioId);
      }

      final snapshot = await query.get();

      final totals = <String, int>{};
      for (final doc in snapshot.docs) {
        final data = doc.data() as Map<String, dynamic>;
        final uid = data['userId'] as String;
        final score = data['score'] as int? ?? 0;
        totals[uid] = (totals[uid] ?? 0) + score;
      }

      final entries = totals.entries
          .map((e) => FriendRankingEntry(userId: e.key, totalScore: e.value))
          .toList()
        ..sort((a, b) => b.totalScore.compareTo(a.totalScore));

      return entries;
    } catch (e) {
      print('Error getting friends ranking: $e');
      return [];
    }
  }
}

class FriendRankingEntry {
  final String userId;
  final int totalScore;

  const FriendRankingEntry({required this.userId, required this.totalScore});
}
