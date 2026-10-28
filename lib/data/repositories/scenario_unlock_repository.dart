import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/scenario_data.dart';

/// シナリオのクリア記録。一覧の並び順で「前のシナリオをクリアすると次が解放される」。
/// 端末内(SharedPreferences)に保存する。ゲストでも動く。
class ScenarioUnlockRepository {
  ScenarioUnlockRepository._();

  static const _key = 'cleared_scenarios_v1';

  /// クリア済みシナリオ名。選択画面はこれを監視して、クリア直後に解放を反映する。
  static final ValueNotifier<Set<String>> cleared =
      ValueNotifier<Set<String>>(<String>{});

  static Future<void> load() async {
    final prefs = await SharedPreferences.getInstance();
    cleared.value = (prefs.getStringList(_key) ?? const <String>[]).toSet();
  }

  static Future<void> markCleared(Scenario scenario) async {
    await load();
    if (cleared.value.contains(scenario.name)) return;
    final next = {...cleared.value, scenario.name};
    final prefs = await SharedPreferences.getInstance();
    await prefs.setStringList(_key, next.toList());
    cleared.value = next;
  }

  /// [order] の [index] 番目が遊べるか。先頭は常に解放、以降は前のシナリオをクリアしたら解放。
  static bool isUnlockedAt(
    int index,
    List<Scenario> order,
    Set<String> clearedNames,
  ) {
    if (index <= 0) return true;
    return clearedNames.contains(order[index - 1].name);
  }
}
