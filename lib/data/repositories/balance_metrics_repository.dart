import 'dart:convert';
import 'package:flutter/services.dart';
import '../models/balance_metrics.dart';
import '../models/scenario_data.dart';
import '../models/difficulty_mode.dart';

/// ゲームバランスメトリクス管理
class BalanceMetricsRepository {
  static final BalanceMetricsRepository _instance =
      BalanceMetricsRepository._internal();

  factory BalanceMetricsRepository() {
    return _instance;
  }

  BalanceMetricsRepository._internal();

  Map<String, dynamic>? _cachedMetrics;

  Future<Map<String, BalanceMetrics>> getAllMetrics() async {
    try {
      _cachedMetrics ??= jsonDecode(
        await rootBundle.loadString('assets/data/balance_metrics.json'),
      ) as Map<String, dynamic>;

      final result = <String, BalanceMetrics>{};
      for (final entry in _cachedMetrics!.entries) {
        result[entry.key] = BalanceMetrics.fromJson(
          entry.value as Map<String, dynamic>,
        );
      }
      return result;
    } catch (e) {
      print('Error loading balance metrics: $e');
      return {};
    }
  }

  /// シナリオと難易度別のメトリクスを取得
  Future<BalanceMetrics?> getMetrics(
    Scenario scenario,
    DifficultyMode difficulty,
  ) async {
    try {
      final all = await getAllMetrics();
      final key = '${scenario.name}_${difficulty.name}';
      return all[key];
    } catch (e) {
      print('Error getting metrics for $scenario/$difficulty: $e');
      return null;
    }
  }

  /// すべてのシナリオの平均勝率を取得
  Future<double> getAverageWinRate() async {
    try {
      final all = await getAllMetrics();
      if (all.isEmpty) return 0.0;
      final sum = all.values.fold<double>(0, (sum, m) => sum + m.playerWinRate);
      return sum / all.length;
    } catch (e) {
      print('Error calculating average win rate: $e');
      return 0.0;
    }
  }

  /// 難易度別の平均勝率を取得
  Future<Map<DifficultyMode, double>> getWinRateByDifficulty() async {
    try {
      final all = await getAllMetrics();
      final result = <DifficultyMode, List<double>>{};

      for (final difficulty in DifficultyMode.values) {
        result[difficulty] = [];
      }

      for (final metrics in all.values) {
        result[metrics.difficulty]?.add(metrics.playerWinRate);
      }

      final averages = <DifficultyMode, double>{};
      for (final difficulty in DifficultyMode.values) {
        final rates = result[difficulty] ?? [];
        if (rates.isNotEmpty) {
          averages[difficulty] =
              rates.fold(0.0, (sum, r) => sum + r) / rates.length;
        } else {
          averages[difficulty] = 0.0;
        }
      }

      return averages;
    } catch (e) {
      print('Error calculating win rate by difficulty: $e');
      return {};
    }
  }

  /// 平均戦闘時間（すべてのシナリオ）
  Future<double> getAverageBattleDuration() async {
    try {
      final all = await getAllMetrics();
      if (all.isEmpty) return 0.0;
      final sum =
          all.values.fold<double>(0, (sum, m) => sum + m.avgBattleDuration);
      return sum / all.length;
    } catch (e) {
      print('Error calculating average battle duration: $e');
      return 0.0;
    }
  }

  /// 難易度別の平均戦闘時間
  Future<Map<DifficultyMode, double>> getBattleDurationByDifficulty() async {
    try {
      final all = await getAllMetrics();
      final result = <DifficultyMode, List<double>>{};

      for (final difficulty in DifficultyMode.values) {
        result[difficulty] = [];
      }

      for (final metrics in all.values) {
        result[metrics.difficulty]?.add(metrics.avgBattleDuration);
      }

      final averages = <DifficultyMode, double>{};
      for (final difficulty in DifficultyMode.values) {
        final durations = result[difficulty] ?? [];
        if (durations.isNotEmpty) {
          averages[difficulty] =
              durations.fold(0.0, (sum, d) => sum + d) / durations.length;
        } else {
          averages[difficulty] = 0.0;
        }
      }

      return averages;
    } catch (e) {
      print('Error calculating battle duration by difficulty: $e');
      return {};
    }
  }

  /// 問題のあるシナリオ/難易度の組み合わせを検出
  Future<List<BalanceDiagnosis>> getProblematicCombinations() async {
    try {
      final all = await getAllMetrics();
      final problems = <BalanceDiagnosis>[];

      for (final metrics in all.values) {
        final diagnosis = metrics.getDiagnosis();
        if (diagnosis.isValid && diagnosis.recommendations.isNotEmpty) {
          problems.add(diagnosis);
        }
      }

      // 推奨数が多い順にソート（問題の深刻度順）
      problems.sort((a, b) => b.recommendations.length.compareTo(a.recommendations.length));
      return problems;
    } catch (e) {
      print('Error detecting problematic combinations: $e');
      return [];
    }
  }

  /// バランスレポートを生成
  Future<String> generateBalanceReport() async {
    try {
      final all = await getAllMetrics();
      final avgWinRate = await getAverageWinRate();
      final avgDuration = await getAverageBattleDuration();
      final winByDiff = await getWinRateByDifficulty();
      final durationByDiff = await getBattleDurationByDifficulty();
      final problems = await getProblematicCombinations();

      final buffer = StringBuffer();
      buffer.writeln('=== ゲームバランスレポート ===\n');

      buffer.writeln('## 総合統計');
      buffer.writeln('- 平均勝率: ${(avgWinRate*100).toStringAsFixed(1)}%');
      buffer.writeln(
          '- 平均戦闘時間: ${(avgDuration/60).toStringAsFixed(1)}分');
      buffer.writeln('- 分析対象: ${all.length}個のシナリオ/難易度組み合わせ\n');

      buffer.writeln('## 難易度別分析');
      for (final diff in DifficultyMode.values) {
        final winRate = winByDiff[diff] ?? 0.0;
        final duration = durationByDiff[diff] ?? 0.0;
        buffer.writeln('- ${diff.displayName}:');
        buffer.writeln('  勝率: ${(winRate*100).toStringAsFixed(1)}%');
        buffer.writeln('  平均時間: ${(duration/60).toStringAsFixed(1)}分');
      }
      buffer.writeln();

      if (problems.isNotEmpty) {
        buffer.writeln('## バランス調整が必要なシナリオ');
        for (final problem in problems.take(10)) {
          buffer.writeln(
              '- ${problem.scenario.name} (${problem.difficulty.displayName}):');
          for (final diag in problem.diagnostics) {
            buffer.writeln('  * $diag');
          }
          for (final rec in problem.recommendations) {
            buffer.writeln('  → $rec');
          }
        }
      } else {
        buffer.writeln('## バランス調整の必要性');
        buffer.writeln('すべてのシナリオのバランスが適切です！');
      }

      return buffer.toString();
    } catch (e) {
      print('Error generating balance report: $e');
      return 'レポート生成エラー: $e';
    }
  }
}
