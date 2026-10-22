import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/battle_replay.dart';
import 'package:flutter/foundation.dart';

/// リプレイ共有リポジトリ
///
/// ローカルにのみ保存されている[BattleReplay]をFirestoreの
/// `shared_replays`コレクションにアップロードし、短い共有コードを発行する。
/// フレンドはコードを受け取って観戦（再生）できる。
class SharedReplayRepository {
  static final SharedReplayRepository _instance =
      SharedReplayRepository._internal();
  factory SharedReplayRepository() => _instance;
  SharedReplayRepository._internal();

  static const String _codeChars = 'ABCDEFGHJKLMNPQRSTUVWXYZ23456789';
  static const int _codeLength = 6;

  CollectionReference get _sharedRepliesRef =>
      FirebaseFirestore.instance.collection('shared_replays');

  String _generateCode() {
    final rand = Random.secure();
    return List.generate(
      _codeLength,
      (_) => _codeChars[rand.nextInt(_codeChars.length)],
    ).join();
  }

  /// リプレイをアップロードし、共有コードを発行する
  Future<String> shareReplay(BattleReplay replay, String sharedByUserId) async {
    for (int attempt = 0; attempt < 5; attempt++) {
      final code = _generateCode();
      final docRef = _sharedRepliesRef.doc(code);
      final existing = await docRef.get();
      if (existing.exists) continue; // 衝突したら再生成

      await docRef.set({
        'replay': replay.toJson(),
        'sharedBy': sharedByUserId,
        'sharedAt': FieldValue.serverTimestamp(),
      });
      return code;
    }
    throw Exception('共有コードの発行に失敗しました。もう一度お試しください');
  }

  /// 共有コードからリプレイを取得
  Future<BattleReplay?> getReplayByCode(String code) async {
    try {
      final doc =
          await _sharedRepliesRef.doc(code.trim().toUpperCase()).get();
      if (!doc.exists) return null;

      final data = doc.data() as Map<String, dynamic>;
      return BattleReplay.fromJson(data['replay'] as Map<String, dynamic>);
    } catch (e) {
      debugPrint('Error fetching shared replay: $e');
      return null;
    }
  }

  /// 共有リプレイの現在のいいね数を取得する
  Future<int> getLikeCount(String code) async {
    try {
      final doc =
          await _sharedRepliesRef.doc(code.trim().toUpperCase()).get();
      if (!doc.exists) return 0;
      final data = doc.data() as Map<String, dynamic>;
      return (data['likes'] as num?)?.toInt() ?? 0;
    } catch (e) {
      debugPrint('Error fetching like count: $e');
      return 0;
    }
  }

  /// 共有リプレイに「いいね」を1件加算する
  Future<int> likeReplay(String code) async {
    final docRef = _sharedRepliesRef.doc(code.trim().toUpperCase());
    try {
      await docRef.update({'likes': FieldValue.increment(1)});
    } catch (e) {
      debugPrint('Error liking replay: $e');
    }
    return getLikeCount(code);
  }

  /// 共有リプレイに短いコメントを投稿する
  Future<void> postComment(
    String code,
    String authorUserId,
    String text,
  ) async {
    final trimmed = text.trim();
    if (trimmed.isEmpty) return;
    final limited = trimmed.length > 140 ? trimmed.substring(0, 140) : trimmed;

    await _sharedRepliesRef
        .doc(code.trim().toUpperCase())
        .collection('comments')
        .add({
      'authorUserId': authorUserId,
      'text': limited,
      'postedAt': FieldValue.serverTimestamp(),
    });
  }

  /// 共有リプレイへのコメント一覧を新しい順に取得する
  Future<List<ReplayComment>> getComments(String code) async {
    try {
      final snapshot = await _sharedRepliesRef
          .doc(code.trim().toUpperCase())
          .collection('comments')
          .orderBy('postedAt', descending: true)
          .limit(50)
          .get();

      return snapshot.docs.map((doc) {
        final data = doc.data();
        return ReplayComment(
          authorUserId: data['authorUserId'] as String? ?? '',
          text: data['text'] as String? ?? '',
          postedAt: (data['postedAt'] as Timestamp?)?.toDate() ?? DateTime.now(),
        );
      }).toList();
    } catch (e) {
      debugPrint('Error fetching replay comments: $e');
      return [];
    }
  }
}

/// 共有リプレイへのコメント1件
class ReplayComment {
  final String authorUserId;
  final String text;
  final DateTime postedAt;

  const ReplayComment({
    required this.authorUserId,
    required this.text,
    required this.postedAt,
  });
}
