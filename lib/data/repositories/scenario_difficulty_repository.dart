import 'package:shared_preferences/shared_preferences.dart';
import '../models/difficulty_mode.dart';
import '../models/scenario_data.dart';

/// シナリオごとに最後に選んだ難易度を記憶するリポジトリ。
///
/// シナリオ選択ダイアログを開くたびに毎回ノーマルへ戻ってしまうと、
/// 同じステージを同じ難易度で周回したいプレイヤーが毎回選び直す
/// 手間を強いられるため、ステージ単位でSharedPreferencesに保存する。
class ScenarioDifficultyRepository {
  static final ScenarioDifficultyRepository _instance =
      ScenarioDifficultyRepository._internal();
  factory ScenarioDifficultyRepository() => _instance;
  ScenarioDifficultyRepository._internal();

  static String _keyFor(Scenario scenario) =>
      'scenario_difficulty_${scenario.name}';

  /// 指定シナリオで最後に選ばれた難易度。未選択なら[DifficultyMode.normal]。
  Future<DifficultyMode> getLastDifficulty(Scenario scenario) async {
    final prefs = await SharedPreferences.getInstance();
    final stored = prefs.getString(_keyFor(scenario));
    if (stored == null) return DifficultyMode.normal;
    try {
      return DifficultyMode.values.byName(stored);
    } catch (_) {
      return DifficultyMode.normal;
    }
  }

  /// 指定シナリオの難易度選択を保存する。
  Future<void> setLastDifficulty(
      Scenario scenario, DifficultyMode difficulty) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_keyFor(scenario), difficulty.name);
  }
}
