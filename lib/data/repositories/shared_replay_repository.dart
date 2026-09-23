import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';
import '../models/battle_replay.dart';

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
      print('Error fetching shared replay: $e');
      return null;
    }
  }
}
