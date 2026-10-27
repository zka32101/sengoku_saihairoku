import 'package:shared_preferences/shared_preferences.dart';
import '../models/scenario_data.dart';
import '../models/difficulty_mode.dart';

/// 戦闘勝利数と、シナリオ×難易度ごとの初回クリア状況をローカルに記録するリポジトリ。
///
/// 実績の「戦闘勝利数」条件や、初回クリアボーナスの判定に使う。
/// リプレイ機能（[ReplayRepository]）とは異なり、ターンごとの詳細を
/// 持たない軽量なカウンターとして端末内（SharedPreferences）に保存する。
class BattleStatsRepository {
  static final BattleStatsRepository _instance =
      BattleStatsRepository._internal();
  factory BattleStatsRepository() => _instance;
  BattleStatsRepository._internal();

  static const _totalWinsKey = 'battle_stats_total_wins';
  static const _totalPlaytimeSecondsKey = 'battle_stats_total_playtime_seconds';
  static const _clearedKeyPrefix = 'battle_stats_cleared_';

  static String _clearedKey(Scenario scenario, DifficultyMode difficulty) =>
      '$_clearedKeyPrefix${scenario.name}_${difficulty.name}';

  /// これまでの戦闘勝利の総数を取得
  Future<int> getTotalWins() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getInt(_totalWinsKey) ?? 0;
  }

  /// 指定シナリオ・難易度が既にクリア済みか
  Future<bool> isCleared(Scenario scenario, DifficultyMode difficulty) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getBool(_clearedKey(scenario, difficulty)) ?? false;
  }

  /// 戦闘勝利を記録する。
  /// 戻り値は、この難易度でのシナリオクリアが今回が初めてかどうか。
  Future<bool> recordVictory(
    Scenario scenario,
    DifficultyMode difficulty,
  ) async {
    final prefs = await SharedPreferences.getInstance();
    final key = _clearedKey(scenario, difficulty);
    final isFirstClear = !(prefs.getBool(key) ?? false);

    final currentWins = prefs.getInt(_totalWinsKey) ?? 0;
    await prefs.setInt(_totalWinsKey, currentWins + 1);
    await prefs.setBool(key, true);

    return isFirstClear;
  }

  /// 戦闘時間（秒）を累計プレイ時間に加算する
  Future<void> addPlaytimeSeconds(int seconds) async {
    final prefs = await SharedPreferences.getInstance();
    final current = prefs.getInt(_totalPlaytimeSecondsKey) ?? 0;
    await prefs.setInt(_totalPlaytimeSecondsKey, current + seconds);
  }

  /// これまでの累計プレイ時間（分）を取得
  Future<int> getTotalPlaytimeMinutes() async {
    final prefs = await SharedPreferences.getInstance();
    final totalSeconds = prefs.getInt(_totalPlaytimeSecondsKey) ?? 0;
    return totalSeconds ~/ 60;
  }
}
