import '../../data/models/scenario_data.dart';
import '../../data/models/difficulty_mode.dart';

/// シナリオ別パフォーマンス分析
class ScenarioPerformance {
  final Scenario scenario;
  final int totalBattles;
  final int victories;
  final int defeats;
  final double winRate;
  final int bestScore;
  final int averageScore;
  final int totalScore;
  final Duration totalPlayTime;
  final Duration averageBattleDuration;
  final int totalTPsAchieved;
  final Map<DifficultyMode, DifficultyPerformance> byDifficulty;
  final DateTime firstBattle;
  final DateTime lastBattle;

  ScenarioPerformance({
    required this.scenario,
    required this.totalBattles,
    required this.victories,
    required this.defeats,
    required this.winRate,
    required this.bestScore,
    required this.averageScore,
    required this.totalScore,
    required this.totalPlayTime,
    required this.averageBattleDuration,
    required this.totalTPsAchieved,
    required this.byDifficulty,
    required this.firstBattle,
    required this.lastBattle,
  });

  String get summary => '${victories}W ${defeats}L (勝率: ${(winRate * 100).toStringAsFixed(1)}%)';

  String get masteryStatus {
    final diffCount = byDifficulty.values.where((d) => d.victoryCount > 0).length;
    if (diffCount == 3) return '完全制覇';
    if (diffCount == 2) return 'ほぼ制覇';
    if (diffCount == 1) return '部分制覇';
    return '未制覇';
  }
}

/// 難易度別パフォーマンス
class DifficultyPerformance {
  final DifficultyMode difficulty;
  final int battleCount;
  final int victoryCount;
  final int defeatCount;
  final double winRate;
  final int bestScore;
  final int averageScore;
  final int totalTPsAchieved;
  final Duration averageDuration;

  DifficultyPerformance({
    required this.difficulty,
    required this.battleCount,
    required this.victoryCount,
    required this.defeatCount,
    required this.winRate,
    required this.bestScore,
    required this.averageScore,
    required this.totalTPsAchieved,
    required this.averageDuration,
  });

  String get summary => '${victoryCount}勝 ${defeatCount}敗';
}

/// 全体統計サマリー
class AdvancedStatisticsSummary {
  final int totalBattles;
  final int totalVictories;
  final int totalDefeats;
  final double overallWinRate;
  final int highestScore;
  final int averageScore;
  final Duration totalPlayTime;
  final Map<Scenario, ScenarioPerformance> byScenario;
  final List<ScenarioPerformance> scenarioRanking; // 勝率でランク付け
  final DifficultyStats difficultyStats;
  final PerformanceTrend performanceTrend;

  AdvancedStatisticsSummary({
    required this.totalBattles,
    required this.totalVictories,
    required this.totalDefeats,
    required this.overallWinRate,
    required this.highestScore,
    required this.averageScore,
    required this.totalPlayTime,
    required this.byScenario,
    required this.scenarioRanking,
    required this.difficultyStats,
    required this.performanceTrend,
  });

  String get playTimeFormatted {
    final hours = totalPlayTime.inHours;
    final minutes = totalPlayTime.inMinutes % 60;
    return '${hours}h ${minutes}m';
  }
}

/// 難易度別統計
class DifficultyStats {
  final Map<DifficultyMode, DifficultyModeStats> stats;

  DifficultyStats({required this.stats});

  DifficultyModeStats? getStats(DifficultyMode difficulty) => stats[difficulty];
}

/// 難易度別詳細統計
class DifficultyModeStats {
  final DifficultyMode difficulty;
  final int totalBattles;
  final int victories;
  final int defeats;
  final double winRate;
  final int averageScore;
  final int scenariosCleared; // クリアしたシナリオ数

  DifficultyModeStats({
    required this.difficulty,
    required this.totalBattles,
    required this.victories,
    required this.defeats,
    required this.winRate,
    required this.averageScore,
    required this.scenariosCleared,
  });

  String get summary => '$scenariosCleared/5シナリオ制覇 (勝率: ${(winRate * 100).toStringAsFixed(1)}%)';
}

/// パフォーマンストレンド
class PerformanceTrend {
  final List<TrendDataPoint> winRateTrend; // 時系列の勝率
  final List<TrendDataPoint> scoreTrend;   // 時系列のスコア
  final double winRateChange;              // 最近の勝率変化
  final double scoreChange;                // 最近のスコア変化
  final String trend;                      // "improving", "stable", "declining"

  PerformanceTrend({
    required this.winRateTrend,
    required this.scoreTrend,
    required this.winRateChange,
    required this.scoreChange,
    required this.trend,
  });
}

/// トレンドデータポイント
class TrendDataPoint {
  final DateTime date;
  final double value;
  final int battleCount; // その日のバトル数

  TrendDataPoint({
    required this.date,
    required this.value,
    required this.battleCount,
  });
}

/// シナリオ別TP達成率
class TPAchievementStats {
  final Scenario scenario;
  final int totalTPsAvailable;
  final int totalTPsAchieved;
  final double achievementRate;
  final Map<DifficultyMode, int> tpsByDifficulty;

  TPAchievementStats({
    required this.scenario,
    required this.totalTPsAvailable,
    required this.totalTPsAchieved,
    required this.achievementRate,
    required this.tpsByDifficulty,
  });

  String get summary => '$totalTPsAchieved/$totalTPsAvailable (達成率: ${(achievementRate * 100).toStringAsFixed(1)}%)';
}
