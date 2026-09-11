import '../../data/models/scenario_data.dart';
import '../../data/models/difficulty_mode.dart';

/// ゲーム全体の統計情報
class GameStatistics {
  final int totalBattles;
  final int totalWins;
  final int totalLosses;
  final double winRate;
  final int totalScore;
  final Duration totalPlayTime;
  final int totalTPsAchieved;
  final int achievementPoints;
  final DateTime firstBattleAt;
  final DateTime lastBattleAt;

  GameStatistics({
    required this.totalBattles,
    required this.totalWins,
    required this.totalLosses,
    required this.winRate,
    required this.totalScore,
    required this.totalPlayTime,
    required this.totalTPsAchieved,
    required this.achievementPoints,
    required this.firstBattleAt,
    required this.lastBattleAt,
  });

  /// 平均スコア
  int get averageScore => totalBattles > 0 ? (totalScore / totalBattles).toInt() : 0;

  /// 平均戦闘時間
  Duration get averageBattleDuration =>
      Duration(seconds: totalBattles > 0 ? totalPlayTime.inSeconds ~/ totalBattles : 0);

  /// 連続勝利日数の概算（最後の勝利からの経過日数）
  int get daysSinceLastWin =>
      DateTime.now().difference(lastBattleAt).inDays;

  factory GameStatistics.fromJson(Map<String, dynamic> json) {
    return GameStatistics(
      totalBattles: json['totalBattles'] as int,
      totalWins: json['totalWins'] as int,
      totalLosses: json['totalLosses'] as int,
      winRate: (json['winRate'] as num).toDouble(),
      totalScore: json['totalScore'] as int,
      totalPlayTime: Duration(seconds: json['totalPlayTimeSeconds'] as int),
      totalTPsAchieved: json['totalTPsAchieved'] as int,
      achievementPoints: json['achievementPoints'] as int,
      firstBattleAt: DateTime.parse(json['firstBattleAt'] as String),
      lastBattleAt: DateTime.parse(json['lastBattleAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'totalBattles': totalBattles,
        'totalWins': totalWins,
        'totalLosses': totalLosses,
        'winRate': winRate,
        'totalScore': totalScore,
        'totalPlayTimeSeconds': totalPlayTime.inSeconds,
        'totalTPsAchieved': totalTPsAchieved,
        'achievementPoints': achievementPoints,
        'firstBattleAt': firstBattleAt.toIso8601String(),
        'lastBattleAt': lastBattleAt.toIso8601String(),
      };
}

/// シナリオ別の統計
class ScenarioStatistics {
  final Scenario scenario;
  final int battleCount;
  final int winCount;
  final double winRate;
  final int bestScore;
  final int averageScore;
  final Duration averageDuration;
  final int totalTPsAchieved;
  final Map<DifficultyMode, DifficultyStatistics> byDifficulty;

  ScenarioStatistics({
    required this.scenario,
    required this.battleCount,
    required this.winCount,
    required this.winRate,
    required this.bestScore,
    required this.averageScore,
    required this.averageDuration,
    required this.totalTPsAchieved,
    required this.byDifficulty,
  });

  factory ScenarioStatistics.fromJson(Map<String, dynamic> json) {
    final byDiffMap = <DifficultyMode, DifficultyStatistics>{};
    if (json['byDifficulty'] is Map) {
      for (final diff in DifficultyMode.values) {
        if (json['byDifficulty'][diff.name] != null) {
          byDiffMap[diff] = DifficultyStatistics.fromJson(
            json['byDifficulty'][diff.name] as Map<String, dynamic>,
          );
        }
      }
    }

    return ScenarioStatistics(
      scenario: Scenario.values.byName(json['scenario'] as String),
      battleCount: json['battleCount'] as int,
      winCount: json['winCount'] as int,
      winRate: (json['winRate'] as num).toDouble(),
      bestScore: json['bestScore'] as int,
      averageScore: json['averageScore'] as int,
      averageDuration: Duration(seconds: json['averageDurationSeconds'] as int),
      totalTPsAchieved: json['totalTPsAchieved'] as int,
      byDifficulty: byDiffMap,
    );
  }

  Map<String, dynamic> toJson() => {
        'scenario': scenario.name,
        'battleCount': battleCount,
        'winCount': winCount,
        'winRate': winRate,
        'bestScore': bestScore,
        'averageScore': averageScore,
        'averageDurationSeconds': averageDuration.inSeconds,
        'totalTPsAchieved': totalTPsAchieved,
        'byDifficulty': {
          for (final entry in byDifficulty.entries) entry.key.name: entry.value.toJson()
        },
      };
}

/// 難易度別の統計
class DifficultyStatistics {
  final DifficultyMode difficulty;
  final int battleCount;
  final int winCount;
  final double winRate;
  final int bestScore;
  final int averageScore;

  DifficultyStatistics({
    required this.difficulty,
    required this.battleCount,
    required this.winCount,
    required this.winRate,
    required this.bestScore,
    required this.averageScore,
  });

  factory DifficultyStatistics.fromJson(Map<String, dynamic> json) {
    return DifficultyStatistics(
      difficulty: DifficultyMode.values.byName(json['difficulty'] as String),
      battleCount: json['battleCount'] as int,
      winCount: json['winCount'] as int,
      winRate: (json['winRate'] as num).toDouble(),
      bestScore: json['bestScore'] as int,
      averageScore: json['averageScore'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'difficulty': difficulty.name,
        'battleCount': battleCount,
        'winCount': winCount,
        'winRate': winRate,
        'bestScore': bestScore,
        'averageScore': averageScore,
      };
}

/// プレイヤーのランク（統計に基づく）
enum PlayerRank {
  novice('初心者', '🥉', 0),
  intermediate('中級者', '🥈', 50),
  advanced('上級者', '🥇', 200),
  master('マスター', '👑', 500);

  final String displayName;
  final String icon;
  final int requiredPoints;

  const PlayerRank(this.displayName, this.icon, this.requiredPoints);

  static PlayerRank fromPoints(int points) {
    for (final rank in PlayerRank.values.reversed) {
      if (points >= rank.requiredPoints) return rank;
    }
    return PlayerRank.novice;
  }
}
