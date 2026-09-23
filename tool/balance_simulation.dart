// 難易度バランス検証用シミュレーター
//
// CLAUDE.md の注意書きの通り、プレイヤーコマンドを一切使わない
// 「無介入シミュレーション」だけでは实プレイのバランスを判断できない
// （このゲームは「不利な兵力を戦術コマンドで覆す」ことが前提のため）。
// このツールは PlayerCommand（奇襲・盾陣・進軍・撤退・鼓舞・突撃等）を
// 実際に発行する簡易的な戦術ボットを介して BattleState をヘッドレスに
// ステップ実行し、既存6シナリオ × 3難易度のクリア率を計測する。
//
// 実行方法（リポジトリルートから）：
//   dart run tool/balance_simulation.dart
//
// 注意：これは数値を自動調整するツールではない。CLAUDE.mdの方針通り、
// バランス調整の判断材料の一つとして使うこと。
import 'dart:convert';
import 'dart:io';
import 'dart:math';

import 'package:sengoku_saihairoku/data/models/difficulty_mode.dart';
import 'package:sengoku_saihairoku/data/models/scenario_data.dart';
import 'package:sengoku_saihairoku/domain/scoring/battle_event_log.dart';
import 'package:sengoku_saihairoku/domain/state/battle_state.dart';

const int _runsPerCombination = 20;
const double _dt = 0.1; // 秒

void main() async {
  final scenariosFile = File('assets/data/scenarios.json');
  if (!scenariosFile.existsSync()) {
    stderr.writeln(
        'assets/data/scenarios.json が見つかりません。リポジトリルートから実行してください。');
    exitCode = 1;
    return;
  }

  final scenariosJson =
      jsonDecode(await scenariosFile.readAsString()) as Map<String, dynamic>;

  final results = <String, Map<DifficultyMode, double>>{};

  for (final entry in scenariosJson.entries) {
    final baseScenario =
        ScenarioData.fromJson(entry.value as Map<String, dynamic>);
    final winRates = <DifficultyMode, double>{};

    for (final mode in DifficultyMode.values) {
      final scenario = _applyDifficulty(baseScenario, mode);
      int wins = 0;

      for (int i = 0; i < _runsPerCombination; i++) {
        if (_simulateOneBattle(scenario, seed: i)) wins++;
      }

      winRates[mode] = wins / _runsPerCombination;
    }

    results[entry.key] = winRates;
  }

  _printReport(results);
}

ScenarioData _applyDifficulty(ScenarioData data, DifficultyMode mode) {
  if (mode == DifficultyMode.normal) return data;

  final adjustedPlayerUnits = data.playerUnits
      .map((u) => UnitDataSnapshot(
            id: u.id,
            name: u.name,
            type: u.type,
            strength: (u.strength * mode.unitStrengthMultiplier).toInt(),
          ))
      .toList();
  final adjustedEnemyUnits = data.enemyUnits
      .map((u) => UnitDataSnapshot(
            id: u.id,
            name: u.name,
            type: u.type,
            strength: (u.strength * mode.enemyUnitStrengthMultiplier).toInt(),
          ))
      .toList();

  return ScenarioData(
    id: data.id,
    displayName: data.displayName,
    year: data.year,
    description: data.description,
    playerInitialStrength:
        adjustedPlayerUnits.fold(0, (sum, u) => sum + u.strength),
    enemyInitialStrength:
        adjustedEnemyUnits.fold(0, (sum, u) => sum + u.strength),
    difficulty: data.difficulty,
    estimatedDuration: data.estimatedDuration,
    backgroundImage: data.backgroundImage,
    turningPoints: data.turningPoints,
    playerUnits: adjustedPlayerUnits,
    enemyUnits: adjustedEnemyUnits,
    alternativePerspective: data.alternativePerspective,
  );
}

/// 単純な戦術ボット方針で1回分の戦闘をヘッドレス実行し、勝利したかを返す。
///
/// 方針（最適ではなく、あくまで「コマンドを使う」ことを再現する目的）：
/// - 開始直後に奇襲
/// - 8秒ごとに、自軍が劣勢なら盾陣、優勢なら突撃
/// - 20秒ごとに鼓舞で攻撃力バフ
bool _simulateOneBattle(ScenarioData scenario, {required int seed}) {
  final random = Random(seed);
  final state = BattleState(scenario: scenario);
  state.start();

  double nextTacticalCommandAt = 8.0;
  double nextRallyAt = 20.0;
  bool ambushed = false;

  while (state.phase != BattlePhase.ended &&
      state.elapsedTime < BattleState.maxBattleTime) {
    state.update(_dt);

    if (!ambushed && state.elapsedTime > 0.5) {
      state.executeCommand(PlayerCommand.ambush);
      ambushed = true;
    }

    if (state.elapsedTime >= nextTacticalCommandAt) {
      final losing = state.playerArmy.getStrengthRatio() <
          state.enemyArmy.getStrengthRatio();
      state.executeCommand(losing ? PlayerCommand.shield : PlayerCommand.charge);
      nextTacticalCommandAt += 8.0 + random.nextDouble() * 2;
    }

    if (state.elapsedTime >= nextRallyAt) {
      state.executeCommand(PlayerCommand.rally);
      nextRallyAt += 20.0;
    }
  }

  return state.result == BattleResult.victory;
}

void _printReport(Map<String, Map<DifficultyMode, double>> results) {
  print('=== 難易度バランス検証（戦術コマンド反映シミュレーション） ===');
  print('試行回数: 各シナリオ×難易度で$_runsPerCombination回\n');

  for (final entry in results.entries) {
    final label = entry.key.padRight(16);
    final rates = entry.value.entries
        .map((e) =>
            '${e.key.name}: ${(e.value * 100).toStringAsFixed(0)}%')
        .join('  ');
    print('$label $rates');
  }
}
