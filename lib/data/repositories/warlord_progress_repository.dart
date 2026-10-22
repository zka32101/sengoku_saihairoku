import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/foundation.dart';

/// 武将の育成（EXP・レベル・覚醒）を管理するリポジトリ。
///
/// 出陣に選んだ武将は勝利のたびにEXPを獲得し、レベルが上がるほど
/// 戦闘（兵力倍率）への貢献がわずかに強くなる。レベル10到達で「覚醒」扱いとし、
/// 図鑑表示で特別な演出を出す。ステータス自体（leadership/valor/intelligence）は
/// `warlords.json`の静的データのまま変更せず、育成分は別レイヤーの倍率として
/// scenario_select_screen側の兵力計算に合成する。
class WarlordProgressRepository {
  static final WarlordProgressRepository _instance =
      WarlordProgressRepository._internal();
  factory WarlordProgressRepository() => _instance;
  WarlordProgressRepository._internal();

  static const int expPerWin = 20;
  static const int expPerLevel = 100;
  static const int maxLevel = 10;

  DocumentReference _progressRef(String userId) => FirebaseFirestore.instance
      .collection('users')
      .doc(userId)
      .collection('collection')
      .doc('warlord_progress');

  /// EXPからレベルを算出（1〜[maxLevel]）
  int levelForExp(int exp) {
    final level = 1 + (exp ~/ expPerLevel);
    return level.clamp(1, maxLevel);
  }

  /// レベルに応じた兵力ボーナス倍率（レベル1で1.0、最大レベルで+18%）
  double strengthBonusForLevel(int level) => 1.0 + (level - 1) * 0.02;

  bool isAwakened(int level) => level >= maxLevel;

  /// 全武将のEXPマップを取得（未保存の武将は0扱い）
  Future<Map<String, int>> getAllExp(String userId) async {
    try {
      final doc = await _progressRef(userId).get();
      if (!doc.exists) return {};
      final data = doc.data() as Map<String, dynamic>;
      final exp = data['exp'] as Map<String, dynamic>? ?? {};
      return exp.map((id, value) => MapEntry(id, (value as num).toInt()));
    } catch (e) {
      debugPrint('Error getting warlord progress: $e');
      return {};
    }
  }

  /// 出陣した武将たちにEXPを加算する（勝利時に呼ぶ）
  Future<void> addExpToWarlords(String userId, List<String> warlordIds) async {
    if (warlordIds.isEmpty) return;
    try {
      final updates = <String, dynamic>{};
      for (final id in warlordIds) {
        updates['exp.$id'] = FieldValue.increment(expPerWin);
      }
      await _progressRef(userId).set(updates, SetOptions(merge: true));
    } catch (e) {
      debugPrint('Error adding warlord exp: $e');
    }
  }
}
