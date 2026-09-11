/// シナリオの教育的コンテンツ
class ScenarioEducation {
  final String scenarioId;
  final String historicalContext;
  final String playerLeader;
  final String playerLeaderInfo;
  final String enemyLeader;
  final String enemyLeaderInfo;
  final List<TurningPointExplanation> turningPointExplanations;
  final String historicalOutcome;

  ScenarioEducation({
    required this.scenarioId,
    required this.historicalContext,
    required this.playerLeader,
    required this.playerLeaderInfo,
    required this.enemyLeader,
    required this.enemyLeaderInfo,
    required this.turningPointExplanations,
    required this.historicalOutcome,
  });

  factory ScenarioEducation.fromJson(Map<String, dynamic> json) {
    return ScenarioEducation(
      scenarioId: json['scenarioId'] as String,
      historicalContext: json['historicalContext'] as String,
      playerLeader: json['playerLeader'] as String,
      playerLeaderInfo: json['playerLeaderInfo'] as String,
      enemyLeader: json['enemyLeader'] as String,
      enemyLeaderInfo: json['enemyLeaderInfo'] as String,
      turningPointExplanations: (json['turningPointExplanations'] as List)
          .map((tp) => TurningPointExplanation.fromJson(
              tp as Map<String, dynamic>))
          .toList(),
      historicalOutcome: json['historicalOutcome'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'scenarioId': scenarioId,
        'historicalContext': historicalContext,
        'playerLeader': playerLeader,
        'playerLeaderInfo': playerLeaderInfo,
        'enemyLeader': enemyLeader,
        'enemyLeaderInfo': enemyLeaderInfo,
        'turningPointExplanations':
            turningPointExplanations.map((tp) => tp.toJson()).toList(),
        'historicalOutcome': historicalOutcome,
      };
}

class TurningPointExplanation {
  final String tpId;
  final String explanation;
  final String historicalSignificance;

  TurningPointExplanation({
    required this.tpId,
    required this.explanation,
    required this.historicalSignificance,
  });

  factory TurningPointExplanation.fromJson(Map<String, dynamic> json) {
    return TurningPointExplanation(
      tpId: json['tpId'] as String,
      explanation: json['explanation'] as String,
      historicalSignificance: json['historicalSignificance'] as String,
    );
  }

  Map<String, dynamic> toJson() => {
        'tpId': tpId,
        'explanation': explanation,
        'historicalSignificance': historicalSignificance,
      };
}
