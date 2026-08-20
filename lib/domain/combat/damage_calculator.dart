import 'dart:math';
import 'unit.dart';

class DamageCalculator {
  static double calculate(Unit attacker, Unit defender) {
    final baseDamage = attacker.effectiveAttack * attacker.strengthRatio;
    final reduced = baseDamage * (1.0 - defender.effectiveDefense);
    final moraleMod = 0.5 + (attacker.morale / 100) * 0.5;
    // 士気が低い部隊は統率が乱れ、被弾がより深刻になる（最大+30%）。
    final defenderMoraleMod = 1.0 + (1.0 - defender.morale / 100) * 0.3;
    final typeMod = _typeModifier(attacker.type, defender.type);

    return max(0, reduced * moraleMod * defenderMoraleMod * typeMod);
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
