import '../models/advanced_statistics.dart';
import '../models/battle_replay.dart';
import '../models/scenario_data.dart';
import '../models/difficulty_mode.dart';
import '../repositories/replay_repository.dart';

/// 統計分析サービス
class StatisticsService {
  static final StatisticsService _instance = StatisticsService._internal();
  final _replayRepo = ReplayRepository();

  factory StatisticsService() {
    return _instance;
  }

  StatisticsService._internal();

  /// 全体的な高度な統計を計算
  Future<AdvancedStatisticsSummary> calculateAdvancedStatistics() async {
    try {
      final replays = await _replayRepo.getAllReplays();

      if (replays.isEmpty) {
        return _createEmptySummary();
      }

      // シナリオ別パフォーマンスを計算
      final scenarioPerformances = <Scenario, ScenarioPerformance>{};
      for (final scenario in Scenario.values) {
        final scenarioReplays = replays.where((r) => r.scenario == scenario).toList();
        if (scenarioReplays.isNotEmpty) {
          scenarioPerformances[scenario] = _calculateScenarioPerformance(
            scenario,
            scenarioReplays,
          );
        }
      }

      // 全体統計
      final totalBattles = replays.length;
      final totalVictories = replays.where((r) => r.isVictory).length;
      final totalDefeats = totalBattles - totalVictories;
      final overallWinRate = totalBattles > 0 ? totalVictories / totalBattles : 0.0;
      final highestScore = replays.isNotEmpty
          ? replays.map((r) => r.finalScore).reduce((a, b) => a > b ? a : b)
          : 0;
      final averageScore = totalBattles > 0
          ? (replays.fold<int>(0, (sum, r) => sum + r.finalScore) / totalBattles).toInt()
          : 0;
      final totalPlayTime = replays.fold<Duration>(
        Duration.zero,
        (sum, r) => sum + r.battleDuration,
      );

      // シナリオランキング（勝率順）
      final scenarioRanking = scenarioPerformances.values.toList()
        ..sort((a, b) => b.winRate.compareTo(a.winRate));

      // 難易度別統計
      final difficultyStats = _calculateDifficultyStats(replays);

      // パフォーマンストレンド
      final performanceTrend = _calculatePerformanceTrend(replays);

      return AdvancedStatisticsSummary(
        totalBattles: totalBattles,
        totalVictories: totalVictories,
        totalDefeats: totalDefeats,
        overallWinRate: overallWinRate,
        highestScore: highestScore,
        averageScore: averageScore,
        totalPlayTime: totalPlayTime,
        byScenario: scenarioPerformances,
        scenarioRanking: scenarioRanking,
        difficultyStats: difficultyStats,
        performanceTrend: performanceTrend,
      );
    } catch (e) {
      print('Error calculating advanced statistics: $e');
      return _createEmptySummary();
    }
  }

  /// シナリオ別パフォーマンスを計算
  ScenarioPerformance _calculateScenarioPerformance(
    Scenario scenario,
    List<BattleReplay> scenarioReplays,
  ) {
    final byDifficulty = <DifficultyMode, DifficultyPerformance>{};

    for (final difficulty in DifficultyMode.values) {
      final diffReplays = scenarioReplays.where((r) => r.difficulty == difficulty).toList();
      if (diffReplays.isNotEmpty) {
        byDifficulty[difficulty] = _calculateDifficultyPerformance(difficulty, diffReplays);
      }
    }

    final victories = scenarioReplays.where((r) => r.isVictory).length;
    final totalBattles = scenarioReplays.length;
    final winRate = totalBattles > 0 ? victories / totalBattles : 0.0;
    final bestScore = scenarioReplays.isNotEmpty
        ? scenarioReplays.map((r) => r.finalScore).reduce((a, b) => a > b ? a : b)
        : 0;
    final averageScore = totalBattles > 0
        ? (scenarioReplays.fold<int>(0, (sum, r) => sum + r.finalScore) / totalBattles).toInt()
        : 0;
    final totalScore = scenarioReplays.fold<int>(0, (sum, r) => sum + r.finalScore);
    final totalPlayTime = scenarioReplays.fold<Duration>(
      Duration.zero,
      (sum, r) => sum + r.battleDuration,
    );
    final averageBattleDuration = Duration(
      seconds: totalBattles > 0 ? totalPlayTime.inSeconds ~/ totalBattles : 0,
    );
    final totalTPsAchieved = scenarioReplays.fold<int>(
      0,
      (sum, r) => sum + r.achievedTPs.length,
    );

    return ScenarioPerformance(
      scenario: scenario,
      totalBattles: totalBattles,
      victories: victories,
      defeats: totalBattles - victories,
      winRate: winRate,
      bestScore: bestScore,
      averageScore: averageScore,
      totalScore: totalScore,
      totalPlayTime: totalPlayTime,
      averageBattleDuration: averageBattleDuration,
      totalTPsAchieved: totalTPsAchieved,
      byDifficulty: byDifficulty,
      firstBattle: scenarioReplays.isNotEmpty
          ? scenarioReplays.map((r) => r.playedAt).reduce((a, b) => a.isBefore(b) ? a : b)
          : DateTime.now(),
      lastBattle: scenarioReplays.isNotEmpty
          ? scenarioReplays.map((r) => r.playedAt).reduce((a, b) => a.isAfter(b) ? a : b)
          : DateTime.now(),
    );
  }

  /// 難易度別パフォーマンスを計算
  DifficultyPerformance _calculateDifficultyPerformance(
    DifficultyMode difficulty,
    List<BattleReplay> diffReplays,
  ) {
    final victoryCount = diffReplays.where((r) => r.isVictory).length;
    final defeatCount = diffReplays.length - victoryCount;
    final winRate = diffReplays.isNotEmpty ? victoryCount / diffReplays.length : 0.0;
    final bestScore = diffReplays.isNotEmpty
        ? diffReplays.map((r) => r.finalScore).reduce((a, b) => a > b ? a : b)
        : 0;
    final averageScore = diffReplays.isNotEmpty
        ? (diffReplays.fold<int>(0, (sum, r) => sum + r.finalScore) / diffReplays.length)
            .toInt()
        : 0;
    final totalTPsAchieved = diffReplays.fold<int>(
      0,
      (sum, r) => sum + r.achievedTPs.length,
    );
    final averageDuration = Duration(
      seconds: diffReplays.isNotEmpty
          ? diffReplays.fold<int>(0, (sum, r) => sum + r.battleDuration.inSeconds) ~/
              diffReplays.length
          : 0,
    );

    return DifficultyPerformance(
      difficulty: difficulty,
      battleCount: diffReplays.length,
      victoryCount: victoryCount,
      defeatCount: defeatCount,
      winRate: winRate,
      bestScore: bestScore,
      averageScore: averageScore,
      totalTPsAchieved: totalTPsAchieved,
      averageDuration: averageDuration,
    );
  }

  /// 難易度別統計を計算
  DifficultyStats _calculateDifficultyStats(List<BattleReplay> replays) {
    final stats = <DifficultyMode, DifficultyModeStats>{};

    for (final difficulty in DifficultyMode.values) {
      final diffReplays = replays.where((r) => r.difficulty == difficulty).toList();

      if (diffReplays.isNotEmpty) {
        final victories = diffReplays.where((r) => r.isVictory).length;
        final totalBattles = diffReplays.length;
        final winRate = victories / totalBattles;
        final averageScore =
            (diffReplays.fold<int>(0, (sum, r) => sum + r.finalScore) / totalBattles)
                .toInt();

        // このボットでクリアしたシナリオ数（少なくとも1勝したシナリオ）
        final clearedScenarios = Scenario.values
            .where((s) =>
                diffReplays.where((r) => r.scenario == s && r.isVictory).isNotEmpty)
            .length;

        stats[difficulty] = DifficultyModeStats(
          difficulty: difficulty,
          totalBattles: totalBattles,
          victories: victories,
          defeats: totalBattles - victories,
          winRate: winRate,
          averageScore: averageScore,
          scenariosCleared: clearedScenarios,
        );
      }
    }

    return DifficultyStats(stats: stats);
  }

  /// パフォーマンストレンドを計算
  PerformanceTrend _calculatePerformanceTrend(List<BattleReplay> replays) {
    if (replays.isEmpty) {
      return PerformanceTrend(
        winRateTrend: [],
        scoreTrend: [],
        winRateChange: 0.0,
        scoreChange: 0.0,
        trend: 'stable',
      );
    }

    // 日付でグループ化
    final replaysByDate = <DateTime, List<BattleReplay>>{};
    for (final replay in replays) {
      final date = DateTime(replay.playedAt.year, replay.playedAt.month, replay.playedAt.day);
      replaysByDate.putIfAbsent(date, () => []).add(replay);
    }

    // ソート
    final sortedDates = replaysByDate.keys.toList()..sort();

    // トレンドデータを計算
    final winRateTrend = <TrendDataPoint>[];
    final scoreTrend = <TrendDataPoint>[];

    for (final date in sortedDates) {
      final dayReplays = replaysByDate[date]!;
      final victories = dayReplays.where((r) => r.isVictory).length;
      final winRate = victories / dayReplays.length;
      final avgScore =
          (dayReplays.fold<int>(0, (sum, r) => sum + r.finalScore) / dayReplays.length)
              .toInt();

      winRateTrend.add(TrendDataPoint(
        date: date,
        value: winRate,
        battleCount: dayReplays.length,
      ));

      scoreTrend.add(TrendDataPoint(
        date: date,
        value: avgScore.toDouble(),
        battleCount: dayReplays.length,
      ));
    }

    // 最近の変化を計算（最後の7日間と比較）
    final recentWindow = 7;
    double winRateChange = 0.0;
    double scoreChange = 0.0;
    String trend = 'stable';

    if (winRateTrend.length > recentWindow) {
      final oldWinRate = winRateTrend[winRateTrend.length - recentWindow - 1].value;
      final newWinRate = winRateTrend.last.value;
      winRateChange = newWinRate - oldWinRate;

      final oldScore = scoreTrend[scoreTrend.length - recentWindow - 1].value;
      final newScore = scoreTrend.last.value;
      scoreChange = newScore - oldScore;

      if (winRateChange > 0.1 && scoreChange > 100) {
        trend = 'improving';
      } else if (winRateChange < -0.1 && scoreChange < -100) {
        trend = 'declining';
      } else {
        trend = 'stable';
      }
    }

    return PerformanceTrend(
      winRateTrend: winRateTrend,
      scoreTrend: scoreTrend,
      winRateChange: winRateChange,
      scoreChange: scoreChange,
      trend: trend,
    );
  }

  /// 空の統計を作成
  AdvancedStatisticsSummary _createEmptySummary() {
    return AdvancedStatisticsSummary(
      totalBattles: 0,
      totalVictories: 0,
      totalDefeats: 0,
      overallWinRate: 0.0,
      highestScore: 0,
      averageScore: 0,
      totalPlayTime: Duration.zero,
      byScenario: {},
      scenarioRanking: [],
      difficultyStats: DifficultyStats(stats: {}),
      performanceTrend: PerformanceTrend(
        winRateTrend: [],
        scoreTrend: [],
        winRateChange: 0.0,
        scoreChange: 0.0,
        trend: 'stable',
      ),
    );
  }
}
