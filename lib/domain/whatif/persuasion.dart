import 'dart:math';

import '../../data/models/scenario_data.dart';
import '../../data/models/warlord_data.dart';

/// 説得に成功したときに戦況へ与える効果。
sealed class WhatIfEffect {
  const WhatIfEffect();

  factory WhatIfEffect.fromJson(Map<String, dynamic> json) {
    switch (json['type'] as String) {
      case 'addPlayerUnit':
        return AddPlayerUnit(
          UnitDataSnapshot.fromJson(json['unit'] as Map<String, dynamic>),
        );
      case 'removeEnemyUnit':
        return RemoveEnemyUnit(json['enemyUnitId'] as String);
      case 'scaleEnemyUnit':
        return ScaleEnemyUnit(
          json['enemyUnitId'] as String,
          (json['factor'] as num).toDouble(),
        );
      default:
        throw FormatException('unknown whatIf effect: ${json['type']}');
    }
  }
}

/// 味方に部隊が加わる（協力者の参陣）。
class AddPlayerUnit extends WhatIfEffect {
  final UnitDataSnapshot unit;
  const AddPlayerUnit(this.unit);
}

/// 敵の部隊が離脱する（寝返り・戦線離脱）。
class RemoveEnemyUnit extends WhatIfEffect {
  final String enemyUnitId;
  const RemoveEnemyUnit(this.enemyUnitId);
}

/// 敵の部隊の兵力が [factor] 倍になる（情報提供・内応で弱体化）。
class ScaleEnemyUnit extends WhatIfEffect {
  final String enemyUnitId;
  final double factor;
  const ScaleEnemyUnit(this.enemyUnitId, this.factor);
}

/// 出陣前に試みる「説得」。成功すると [effects] が戦況に反映される。
class Persuasion {
  final String id;
  final String name;
  final String description;
  final String successText;
  final String failureText;
  final double baseSuccessRate;
  final List<WhatIfEffect> effects;

  const Persuasion({
    required this.id,
    required this.name,
    required this.description,
    required this.successText,
    required this.failureText,
    required this.baseSuccessRate,
    required this.effects,
  });

  factory Persuasion.fromJson(Map<String, dynamic> json) {
    return Persuasion(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String,
      successText: json['successText'] as String,
      failureText: json['failureText'] as String,
      baseSuccessRate: (json['baseSuccessRate'] as num).toDouble(),
      effects: (json['effects'] as List)
          .map((e) => WhatIfEffect.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  /// 出陣武将の知略が高いほど成功しやすい（平均知略100で+20%、上限95%）。
  /// 武将を出陣させていなければ基本の成功率のまま。
  double successRate(List<Warlord> sortied) {
    if (sortied.isEmpty) return baseSuccessRate.clamp(0.0, 0.95);
    final avg =
        sortied.fold<int>(0, (s, w) => s + w.intelligence) / sortied.length;
    final bonus = (avg / 100.0).clamp(0.0, 1.0) * 0.2;
    return (baseSuccessRate + bonus).clamp(0.0, 0.95);
  }

  bool attempt(List<Warlord> sortied, Random random) =>
      random.nextDouble() < successRate(sortied);
}

/// 成功した説得の効果を [data] に反映した新しい [ScenarioData] を返す。
ScenarioData applyWhatIfEffects(
  ScenarioData data,
  List<WhatIfEffect> effects,
) {
  if (effects.isEmpty) return data;

  var player = List<UnitDataSnapshot>.of(data.playerUnits);
  var enemy = List<UnitDataSnapshot>.of(data.enemyUnits);

  for (final effect in effects) {
    switch (effect) {
      case AddPlayerUnit(:final unit):
        player.add(unit);
      case RemoveEnemyUnit(:final enemyUnitId):
        enemy = enemy.where((u) => u.id != enemyUnitId).toList();
      case ScaleEnemyUnit(:final enemyUnitId, :final factor):
        enemy = enemy
            .map((u) => u.id == enemyUnitId
                ? UnitDataSnapshot(
                    id: u.id,
                    name: u.name,
                    type: u.type,
                    strength: max(1, (u.strength * factor).round()),
                  )
                : u)
            .toList();
    }
  }

  int total(List<UnitDataSnapshot> units) =>
      units.fold(0, (sum, u) => sum + u.strength);

  return ScenarioData(
    id: data.id,
    displayName: data.displayName,
    year: data.year,
    description: data.description,
    playerInitialStrength: total(player),
    enemyInitialStrength: total(enemy),
    difficulty: data.difficulty,
    estimatedDuration: data.estimatedDuration,
    backgroundImage: data.backgroundImage,
    turningPoints: data.turningPoints,
    playerUnits: player,
    enemyUnits: enemy,
    alternativePerspective: data.alternativePerspective,
  );
}
