enum Scenario {
  odigahara,
  nagashino,
  honnoJi,
  sekigahara,
}

class ScenarioData {
  final Scenario id;
  final String displayName;
  final int year;
  final String description;
  final int playerInitialStrength;
  final int enemyInitialStrength;
  final int difficulty;
  final int estimatedDuration;
  final String backgroundImage;
  final List<TurningPoint> turningPoints;
  final List<UnitDataSnapshot> playerUnits;
  final List<UnitDataSnapshot> enemyUnits;

  ScenarioData({
    required this.id,
    required this.displayName,
    required this.year,
    required this.description,
    required this.playerInitialStrength,
    required this.enemyInitialStrength,
    required this.difficulty,
    required this.estimatedDuration,
    required this.backgroundImage,
    required this.turningPoints,
    required this.playerUnits,
    required this.enemyUnits,
  });

  factory ScenarioData.fromJson(Map<String, dynamic> json) {
    return ScenarioData(
      id: Scenario.values.byName(json['id'] as String),
      displayName: json['displayName'] as String,
      year: json['year'] as int,
      description: json['description'] as String,
      playerInitialStrength: json['playerInitialStrength'] as int,
      enemyInitialStrength: json['enemyInitialStrength'] as int,
      difficulty: json['difficulty'] as int,
      estimatedDuration: json['estimatedDuration'] as int,
      backgroundImage: json['backgroundImage'] as String,
      turningPoints: (json['turningPoints'] as List)
          .map((tp) => TurningPoint.fromJson(tp as Map<String, dynamic>))
          .toList(),
      playerUnits: (json['playerUnits'] as List)
          .map((u) => UnitDataSnapshot.fromJson(u as Map<String, dynamic>))
          .toList(),
      enemyUnits: (json['enemyUnits'] as List)
          .map((u) => UnitDataSnapshot.fromJson(u as Map<String, dynamic>))
          .toList(),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id.name,
        'displayName': displayName,
        'year': year,
        'description': description,
        'playerInitialStrength': playerInitialStrength,
        'enemyInitialStrength': enemyInitialStrength,
        'difficulty': difficulty,
        'estimatedDuration': estimatedDuration,
        'backgroundImage': backgroundImage,
        'turningPoints': turningPoints.map((tp) => tp.toJson()).toList(),
        'playerUnits': playerUnits.map((u) => u.toJson()).toList(),
        'enemyUnits': enemyUnits.map((u) => u.toJson()).toList(),
      };
}

class TurningPoint {
  final String id;
  final String name;
  final String description;
  final int rewardPoints;

  TurningPoint({
    required this.id,
    required this.name,
    required this.description,
    required this.rewardPoints,
  });

  factory TurningPoint.fromJson(Map<String, dynamic> json) {
    return TurningPoint(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      rewardPoints: json['rewardPoints'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'rewardPoints': rewardPoints,
      };
}

class UnitDataSnapshot {
  final String id;
  final String name;
  final String type;
  final int strength;

  UnitDataSnapshot({
    required this.id,
    required this.name,
    required this.type,
    required this.strength,
  });

  factory UnitDataSnapshot.fromJson(Map<String, dynamic> json) {
    return UnitDataSnapshot(
      id: json['id'] as String,
      name: json['name'] as String,
      type: json['type'] as String,
      strength: json['strength'] as int,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'type': type,
        'strength': strength,
      };
}

