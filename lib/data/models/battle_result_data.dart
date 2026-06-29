import 'scenario_data.dart';

class BattleResultData {
  final String id;
  final String userId;
  final Scenario scenarioId;
  final DateTime playedAt;
  final int duration;
  final bool won;
  final int finalPlayerStrength;
  final int finalEnemyStrength;
  final int totalScore;
  final ScoreBreakdown scoreBreakdown;
  final List<String> achievedTurningPoints;
  final List<BattleCommandSnapshot> commands;
  final String? messageId;

  BattleResultData({
    required this.id,
    required this.userId,
    required this.scenarioId,
    required this.playedAt,
    required this.duration,
    required this.won,
    required this.finalPlayerStrength,
    required this.finalEnemyStrength,
    required this.totalScore,
    required this.scoreBreakdown,
    required this.achievedTurningPoints,
    required this.commands,
    this.messageId,
  });

  factory BattleResultData.fromJson(Map<String, dynamic> json) {
    return BattleResultData(
      id: json['id'] as String,
      userId: json['userId'] as String,
      scenarioId:
          Scenario.values.byName(json['scenarioId'] as String),
      playedAt: DateTime.parse(json['playedAt'] as String),
      duration: json['duration'] as int,
      won: json['won'] as bool,
      finalPlayerStrength: json['finalPlayerStrength'] as int,
      finalEnemyStrength: json['finalEnemyStrength'] as int,
      totalScore: json['totalScore'] as int,
      scoreBreakdown: ScoreBreakdown.fromJson(
          json['scoreBreakdown'] as Map<String, dynamic>),
      achievedTurningPoints:
          List<String>.from(json['achievedTurningPoints'] as List),
      commands: (json['commands'] as List)
          .map((c) =>
              BattleCommandSnapshot.fromJson(c as Map<String, dynamic>))
          .toList(),
      messageId: json['messageId'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'scenarioId': scenarioId.name,
        'playedAt': playedAt.toIso8601String(),
        'duration': duration,
        'won': won,
        'finalPlayerStrength': finalPlayerStrength,
        'finalEnemyStrength': finalEnemyStrength,
        'totalScore': totalScore,
        'scoreBreakdown': scoreBreakdown.toJson(),
        'achievedTurningPoints': achievedTurningPoints,
        'commands': commands.map((c) => c.toJson()).toList(),
        'messageId': messageId,
      };
}

class ScoreBreakdown {
  final int victoryScore;
  final int efficiencyScore;
  final int commandScore;
  final int turningPointScore;
  final int historyBonus;

  int get total =>
      victoryScore + efficiencyScore + commandScore + turningPointScore + historyBonus;

  ScoreBreakdown({
    required this.victoryScore,
    required this.efficiencyScore,
    required this.commandScore,
    required this.turningPointScore,
    required this.historyBonus,
  });

  factory ScoreBreakdown.fromJson(Map<String, dynamic> json) {
    return ScoreBreakdown(
      victoryScore: json['victoryScore'] as int,
      efficiencyScore: json['efficiencyScore'] as int,
      commandScore: json['commandScore'] as int,
      turningPointScore: json['turningPointScore'] as int,
      historyBonus: json['historyBonus'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'victoryScore': victoryScore,
        'efficiencyScore': efficiencyScore,
        'commandScore': commandScore,
        'turningPointScore': turningPointScore,
        'historyBonus': historyBonus,
      };
}

class BattleCommandSnapshot {
  final DateTime timestamp;
  final String commandType;
  final int duration;

  BattleCommandSnapshot({
    required this.timestamp,
    required this.commandType,
    required this.duration,
  });

  factory BattleCommandSnapshot.fromJson(Map<String, dynamic> json) {
    return BattleCommandSnapshot(
      timestamp: DateTime.parse(json['timestamp'] as String),
      commandType: json['commandType'] as String,
      duration: json['duration'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'timestamp': timestamp.toIso8601String(),
        'commandType': commandType,
        'duration': duration,
      };
}
