import 'dart:convert';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../models/battle_replay.dart';
import '../../data/models/scenario_data.dart';
import '../../data/models/difficulty_mode.dart';

/// バトルリプレイ管理リポジトリ
class ReplayRepository {
  static final ReplayRepository _instance = ReplayRepository._internal();
  static const String _replayKeyPrefix = 'replay_';
  static const String _replayListKey = 'replay_list';
  static const int _maxReplaysStored = 100; // 最大保存リプレイ数

  factory ReplayRepository() {
    return _instance;
  }

  ReplayRepository._internal();

  /// リプレイを保存
  Future<void> saveReplay(BattleReplay replay) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = jsonEncode(replay.toJson());

      // リプレイデータを保存
      await prefs.setString(_replayKeyPrefix + replay.id, json);

      // リプレイリストを更新
      List<String> replayIds = prefs.getStringList(_replayListKey) ?? [];

      // 重複排除
      if (!replayIds.contains(replay.id)) {
        replayIds.add(replay.id);

        // 最大数を超えた場合、古いものを削除
        if (replayIds.length > _maxReplaysStored) {
          final toDelete = replayIds.removeAt(0);
          await prefs.remove(_replayKeyPrefix + toDelete);
        }

        await prefs.setStringList(_replayListKey, replayIds);
      }
    } catch (e) {
      print('Error saving replay: $e');
      rethrow;
    }
  }

  /// IDでリプレイを取得
  Future<BattleReplay?> getReplayById(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final json = prefs.getString(_replayKeyPrefix + id);

      if (json == null) return null;

      return BattleReplay.fromJson(
        jsonDecode(json) as Map<String, dynamic>,
      );
    } catch (e) {
      print('Error getting replay $id: $e');
      return null;
    }
  }

  /// すべてのリプレイを取得（最新順）
  Future<List<BattleReplay>> getAllReplays() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final replayIds = prefs.getStringList(_replayListKey) ?? [];

      final replays = <BattleReplay>[];
      for (final id in replayIds.reversed) {
        final replay = await getReplayById(id);
        if (replay != null) {
          replays.add(replay);
        }
      }

      return replays;
    } catch (e) {
      print('Error getting all replays: $e');
      return [];
    }
  }

  /// シナリオ別にリプレイを取得
  Future<List<BattleReplay>> getReplaysByScenario(Scenario scenario) async {
    try {
      final all = await getAllReplays();
      return all.where((r) => r.scenario == scenario).toList();
    } catch (e) {
      print('Error getting replays by scenario: $e');
      return [];
    }
  }

  /// 難易度別にリプレイを取得
  Future<List<BattleReplay>> getReplaysByDifficulty(DifficultyMode difficulty) async {
    try {
      final all = await getAllReplays();
      return all.where((r) => r.difficulty == difficulty).toList();
    } catch (e) {
      print('Error getting replays by difficulty: $e');
      return [];
    }
  }

  /// 勝利のみのリプレイを取得
  Future<List<BattleReplay>> getVictoryReplays() async {
    try {
      final all = await getAllReplays();
      return all.where((r) => r.isVictory).toList();
    } catch (e) {
      print('Error getting victory replays: $e');
      return [];
    }
  }

  /// 敗北のみのリプレイを取得
  Future<List<BattleReplay>> getDefeatReplays() async {
    try {
      final all = await getAllReplays();
      return all.where((r) => !r.isVictory).toList();
    } catch (e) {
      print('Error getting defeat replays: $e');
      return [];
    }
  }

  /// リプレイを削除
  Future<void> deleteReplay(String id) async {
    try {
      final prefs = await SharedPreferences.getInstance();

      await prefs.remove(_replayKeyPrefix + id);

      List<String> replayIds = prefs.getStringList(_replayListKey) ?? [];
      replayIds.removeWhere((rid) => rid == id);
      await prefs.setStringList(_replayListKey, replayIds);
    } catch (e) {
      print('Error deleting replay $id: $e');
      rethrow;
    }
  }

  /// すべてのリプレイを削除
  Future<void> deleteAllReplays() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final replayIds = prefs.getStringList(_replayListKey) ?? [];

      for (final id in replayIds) {
        await prefs.remove(_replayKeyPrefix + id);
      }

      await prefs.remove(_replayListKey);
    } catch (e) {
      print('Error deleting all replays: $e');
      rethrow;
    }
  }

  /// リプレイ統計を取得
  Future<ReplayStats> getStats() async {
    try {
      final all = await getAllReplays();

      final victories = all.where((r) => r.isVictory).length;
      final defeats = all.where((r) => !r.isVictory).length;
      final avgScore = all.isNotEmpty
          ? (all.fold<int>(0, (sum, r) => sum + r.finalScore) / all.length)
              .toInt()
          : 0;

      final scenarioMap = <String, int>{};
      for (final replay in all) {
        final name = replay.scenario.name;
        scenarioMap[name] = (scenarioMap[name] ?? 0) + 1;
      }

      return ReplayStats(
        totalReplays: all.length,
        victories: victories,
        defeats: defeats,
        winRate: all.isNotEmpty
            ? (victories / all.length * 100).toStringAsFixed(1)
            : '0.0',
        averageScore: avgScore,
        byScenario: scenarioMap,
      );
    } catch (e) {
      print('Error getting replay stats: $e');
      return ReplayStats(
        totalReplays: 0,
        victories: 0,
        defeats: 0,
        winRate: '0.0',
        averageScore: 0,
        byScenario: {},
      );
    }
  }
}

/// リプレイ統計
class ReplayStats {
  final int totalReplays;
  final int victories;
  final int defeats;
  final String winRate;
  final int averageScore;
  final Map<String, int> byScenario;

  ReplayStats({
    required this.totalReplays,
    required this.victories,
    required this.defeats,
    required this.winRate,
    required this.averageScore,
    required this.byScenario,
  });

  String get summary => '$victories勝 $defeats敗 (勝率: $winRate%)';
}
