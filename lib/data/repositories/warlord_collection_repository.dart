import 'dart:math';
import 'package:cloud_firestore/cloud_firestore.dart';

/// 武将コレクション（図鑑）管理リポジトリ
///
/// [WarlordRepository]が読み込む`warlords.json`の静的データに対して、
/// 「どの武将を解放済みか」というユーザーごとの進捗をFirestoreに保存する。
/// 戦闘（Unit/Army）への反映は引き続きスコープ外（warlord_data.dart参照）で、
/// 収集・図鑑要素のみを提供する。
class WarlordCollectionRepository {
  static final WarlordCollectionRepository _instance =
      WarlordCollectionRepository._internal();
  factory WarlordCollectionRepository() => _instance;
  WarlordCollectionRepository._internal();

  static const int gachaCost = 150;

  DocumentReference _collectionRef(String userId) => FirebaseFirestore
      .instance
      .collection('users')
      .doc(userId)
      .collection('collection')
      .doc('warlords');

  /// 解放済み武将IDの一覧を取得
  Future<Set<String>> getUnlockedWarlordIds(String userId) async {
    try {
      final doc = await _collectionRef(userId).get();
      if (!doc.exists) return {};
      final data = doc.data() as Map<String, dynamic>;
      return Set<String>.from(data['unlocked'] as List? ?? []);
    } catch (e) {
      print('Error getting unlocked warlords: $e');
      return {};
    }
  }

  /// 武将を解放済みとして記録
  Future<void> unlockWarlord(String userId, String warlordId) async {
    await _collectionRef(userId).set({
      'unlocked': FieldValue.arrayUnion([warlordId]),
    }, SetOptions(merge: true));
  }

  /// 未解放の武将からランダムに1体選ぶ（全解放済みならnullを返す）
  String? drawRandom(List<String> allWarlordIds, Set<String> unlockedIds) {
    final candidates =
        allWarlordIds.where((id) => !unlockedIds.contains(id)).toList();
    if (candidates.isEmpty) return null;
    return candidates[Random().nextInt(candidates.length)];
  }
}
