import 'dart:math';
import 'unit.dart';

class DamageCalculator {
  static double calculate(Unit attacker, Unit defender) {
    final baseDamage = attacker.attack * attacker.strengthRatio;
    final reduced = baseDamage * (1.0 - defender.defense);
    final moraleMod = 0.5 + (attacker.morale / 100) * 0.5;
    final typeMod = _typeModifier(attacker.type, defender.type);

    return max(0, reduced * moraleMod * typeMod);
  }

  static double _typeModifier(UnitType attacker, UnitType defender) {
    // 三すくみ + 鉄砲有利
    if (attacker == UnitType.cavalry && defender == UnitType.archer) return 1.5;
    if (attacker == UnitType.archer && defender == UnitType.spear) return 1.5;
    if (attacker == UnitType.spear && defender == UnitType.cavalry) return 1.5;
    if (attacker == UnitType.musket && defender == UnitType.cavalry) return 2.0;
    return 1.0;
  }
}
