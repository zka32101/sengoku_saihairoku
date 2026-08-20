import 'unit.dart';

class Army {
  final String commanderName;
  final List<Unit> units;

  Army({required this.commanderName, required this.units});

  double getTotalStrength() {
    return units.fold(0.0, (sum, u) => sum + u.strength);
  }

  double getMaxStrength() {
    return units.fold(0.0, (sum, u) => sum + u.maxStrength);
  }

  double getStrengthRatio() {
    final max = getMaxStrength();
    return max > 0 ? getTotalStrength() / max : 0.0;
  }

  double getAverageMorale() {
    final alive = units.where((u) => !u.isDead).toList();
    if (alive.isEmpty) return 0;
    return alive.fold(0.0, (sum, u) => sum + u.morale) / alive.length;
  }

  bool get isDefeated => units.every((u) => u.isDead);

  List<Unit> get aliveUnits => units.where((u) => !u.isDead).toList();

  (double, double) getCenterPosition() {
    final alive = aliveUnits;
    if (alive.isEmpty) return (0, 0);
    final x = alive.fold(0.0, (sum, u) => sum + u.posX) / alive.length;
    final y = alive.fold(0.0, (sum, u) => sum + u.posY) / alive.length;
    return (x, y);
  }

  /// 指定座標から見て最も近い生存ユニットを返す（いなければ null）。
  /// 進軍中のユニットが「目の前の敵」を追うために使う。
  Unit? nearestAliveTo(double x, double y) {
    Unit? nearest;
    double bestDistSq = double.infinity;
    for (final u in aliveUnits) {
      final dx = u.posX - x;
      final dy = u.posY - y;
      final distSq = dx * dx + dy * dy;
      if (distSq < bestDistSq) {
        bestDistSq = distSq;
        nearest = u;
      }
    }
    return nearest;
  }
}
