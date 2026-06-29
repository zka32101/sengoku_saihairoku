import 'scenario_data.dart';
import 'battle_result_data.dart';

class FirebaseUser {
  final String uid;
  final String displayName;
  final DateTime createdAt;
  final DateTime lastPlayedAt;
  final int totalPlayed;
  final int totalWins;
  final int bestScore;
  final List<ScenarioProgress> scenarioProgress;

  FirebaseUser({
    required this.uid,
    required this.displayName,
    required this.createdAt,
    required this.lastPlayedAt,
    required this.totalPlayed,
    required this.totalWins,
    required this.bestScore,
    required this.scenarioProgress,
  });

  factory FirebaseUser.fromJson(Map<String, dynamic> json) {
    return FirebaseUser(
      uid: json['uid'] as String,
      displayName: json['displayName'] as String,
      createdAt: DateTime.parse(json['createdAt'] as String),
      lastPlayedAt: DateTime.parse(json['lastPlayedAt'] as String),
      totalPlayed: json['totalPlayed'] as int,
      totalWins: json['totalWins'] as int,
      bestScore: json['bestScore'] as int,
      scenarioProgress: (json['scenarioProgress'] as List)
          .map((p) =>
              ScenarioProgress.fromJson(p as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'uid': uid,
        'displayName': displayName,
        'createdAt': createdAt.toIso8601String(),
        'lastPlayedAt': lastPlayedAt.toIso8601String(),
        'totalPlayed': totalPlayed,
        'totalWins': totalWins,
        'bestScore': bestScore,
        'scenarioProgress':
            scenarioProgress.map((p) => p.toJson()).toList(),
      };
}

class ScenarioProgress {
  final Scenario scenarioId;
  final int timesPlayed;
  final int timesWon;
  final int bestScore;
  final List<String> achievedTurningPoints;
  final bool isUnlocked;

  ScenarioProgress({
    required this.scenarioId,
    required this.timesPlayed,
    required this.timesWon,
    required this.bestScore,
    required this.achievedTurningPoints,
    required this.isUnlocked,
  });

  factory ScenarioProgress.fromJson(Map<String, dynamic> json) {
    return ScenarioProgress(
      scenarioId:
          Scenario.values.byName(json['scenarioId'] as String),
      timesPlayed: json['timesPlayed'] as int,
      timesWon: json['timesWon'] as int,
      bestScore: json['bestScore'] as int,
      achievedTurningPoints:
          List<String>.from(json['achievedTurningPoints'] as List),
      isUnlocked: json['isUnlocked'] as bool,
    );
  }

  Map<String, dynamic> toJson() => {
        'scenarioId': scenarioId.name,
        'timesPlayed': timesPlayed,
        'timesWon': timesWon,
        'bestScore': bestScore,
        'achievedTurningPoints': achievedTurningPoints,
        'isUnlocked': isUnlocked,
      };
}

class RankingEntry {
  final int rank;
  final String userId;
  final String displayName;
  final Scenario scenarioId;
  final int bestScore;
  final DateTime achievedAt;
  final int turningPointsAchieved;

  RankingEntry({
    required this.rank,
    required this.userId,
    required this.displayName,
    required this.scenarioId,
    required this.bestScore,
    required this.achievedAt,
    required this.turningPointsAchieved,
  });

  factory RankingEntry.fromJson(Map<String, dynamic> json) {
    return RankingEntry(
      rank: json['rank'] as int,
      userId: json['userId'] as String,
      displayName: json['displayName'] as String,
      scenarioId:
          Scenario.values.byName(json['scenarioId'] as String),
      bestScore: json['bestScore'] as int,
      achievedAt: DateTime.parse(json['achievedAt'] as String),
      turningPointsAchieved: json['turningPointsAchieved'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'rank': rank,
        'userId': userId,
        'displayName': displayName,
        'scenarioId': scenarioId.name,
        'bestScore': bestScore,
        'achievedAt': achievedAt.toIso8601String(),
        'turningPointsAchieved': turningPointsAchieved,
      };
}

class ReplayData {
  final String id;
  final String userId;
  final Scenario scenarioId;
  final int score;
  final List<BattleCommandSnapshot> commands;
  final DateTime recordedAt;

  ReplayData({
    required this.id,
    required this.userId,
    required this.scenarioId,
    required this.score,
    required this.commands,
    required this.recordedAt,
  });

  factory ReplayData.fromJson(Map<String, dynamic> json) {
    return ReplayData(
      id: json['id'] as String,
      userId: json['userId'] as String,
      scenarioId:
          Scenario.values.byName(json['scenarioId'] as String),
      score: json['score'] as int,
      commands: (json['commands'] as List)
          .map((c) =>
              BattleCommandSnapshot.fromJson(c as Map<String, dynamic>))
          .toList(),
      recordedAt: DateTime.parse(json['recordedAt'] as String),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'scenarioId': scenarioId.name,
        'score': score,
        'commands': commands.map((c) => c.toJson()).toList(),
        'recordedAt': recordedAt.toIso8601String(),
      };
}
