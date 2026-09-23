import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/battle_result_data.dart';

/// オフライン等で`FirebaseService.saveBattleResult()`の書き込みに失敗した
/// バトル結果を端末内に保持し、次回成功時に再送するキュー。
///
/// 以前は書き込み失敗時に例外を握りつぶすだけで、スコア・ゴールド・実績が
/// 静かに失われていた（クリア後は二度と復元できない）。このキューは
/// その場しのぎではなく、次にオンラインになった時に確実に送るための
/// 永続化層として機能する。
class PendingBattleResultQueue {
  static final PendingBattleResultQueue _instance =
      PendingBattleResultQueue._internal();
  factory PendingBattleResultQueue() => _instance;
  PendingBattleResultQueue._internal();

  static const String _storageKey = 'pending_battle_results';
  static const int _maxQueueSize = 50; // 際限なく溜め込まないための上限

  Future<void> enqueue(BattleResultData result) async {
    final prefs = await SharedPreferences.getInstance();
    final queue = prefs.getStringList(_storageKey) ?? [];

    // 同じIDが既にキューにあれば重複させない
    queue.removeWhere((entry) {
      try {
        return (jsonDecode(entry) as Map<String, dynamic>)['id'] == result.id;
      } catch (_) {
        return false;
      }
    });

    queue.add(jsonEncode(result.toJson()));

    // 上限を超えたら古いものから捨てる（無限増殖の防止を優先）
    while (queue.length > _maxQueueSize) {
      queue.removeAt(0);
    }

    await prefs.setStringList(_storageKey, queue);
  }

  Future<List<BattleResultData>> getAll() async {
    final prefs = await SharedPreferences.getInstance();
    final queue = prefs.getStringList(_storageKey) ?? [];

    final results = <BattleResultData>[];
    for (final entry in queue) {
      try {
        results.add(
            BattleResultData.fromJson(jsonDecode(entry) as Map<String, dynamic>));
      } catch (e) {
        print('Error decoding queued battle result: $e');
      }
    }
    return results;
  }

  Future<void> remove(String resultId) async {
    final prefs = await SharedPreferences.getInstance();
    final queue = prefs.getStringList(_storageKey) ?? [];

    queue.removeWhere((entry) {
      try {
        return (jsonDecode(entry) as Map<String, dynamic>)['id'] == resultId;
      } catch (_) {
        return false;
      }
    });

    await prefs.setStringList(_storageKey, queue);
  }

  Future<int> get pendingCount async {
    final prefs = await SharedPreferences.getInstance();
    return (prefs.getStringList(_storageKey) ?? []).length;
  }
}
