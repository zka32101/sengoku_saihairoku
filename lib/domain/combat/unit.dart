import 'dart:math';

enum UnitType { cavalry, archer, spear, musket }

class Unit {
  final String id;
  final String name;
  final double maxStrength;
  final double attack;
  final double defense;
  final UnitType type;

  double strength;
  double morale;
  double speed;

  double posX;
  double posY;
  double targetX;
  double targetY;
  bool isMoving = false;
  bool isColliding = false;

  // バフ状態（残り時間で管理）
  double attackBuffTimer = 0;   // 攻撃力バフ残り秒
  double defenseBuffTimer = 0;  // 防御力バフ残り秒
  double speedBuffTimer = 0;    // 速度バフ残り秒

  static const double attackBuffMultiplier = 1.5;
  static const double defenseBuffMultiplier = 1.5;
  static const double speedBuffMultiplier = 1.8;

  Unit({
    required this.id,
    required this.name,
    required this.maxStrength,
    required this.attack,
    required this.defense,
    required this.morale,
    required this.speed,
    required this.type,
    required this.posX,
    required this.posY,
  })  : strength = maxStrength,
        targetX = posX,
        targetY = posY;

  // hp は strength の別名（UIパネル向け）
  double get hp => strength;
  double get maxHp => maxStrength;
  double get effectiveAttack => attackBuffTimer > 0 ? attack * attackBuffMultiplier : attack;
  double get effectiveDefense => defenseBuffTimer > 0 ? defense * defenseBuffMultiplier : defense;
  double get effectiveSpeed => speedBuffTimer > 0 ? speed * speedBuffMultiplier : speed;

  bool get hasAttackBuff => attackBuffTimer > 0;
  bool get hasDefenseBuff => defenseBuffTimer > 0;
  bool get hasSpeedBuff => speedBuffTimer > 0;

  void update(double dt) {
    // バフタイマー更新
    if (attackBuffTimer > 0) attackBuffTimer = max(0, attackBuffTimer - dt);
    if (defenseBuffTimer > 0) defenseBuffTimer = max(0, defenseBuffTimer - dt);
    if (speedBuffTimer > 0) speedBuffTimer = max(0, speedBuffTimer - dt);

    if (!isMoving) return;

    final dx = targetX - posX;
    final dy = targetY - posY;
    final dist = sqrt(dx * dx + dy * dy);

    if (dist < 10) {
      isMoving = false;
      return;
    }

    posX += (dx / dist) * effectiveSpeed * dt;
    posY += (dy / dist) * effectiveSpeed * dt;
  }

  void takeDamage(double damage) {
    strength = max(0, strength - damage);
    if (damage > maxStrength * 0.05) {
      morale = max(0, morale - 5);
    }
  }

  double distanceTo(Unit other) {
    final dx = posX - other.posX;
    final dy = posY - other.posY;
    return sqrt(dx * dx + dy * dy);
  }

  bool get isDead => strength <= 0;

  double get strengthRatio => strength / maxStrength;
}

Unit createUnitFromType(
    String id, String name, UnitType type, int strength, double posX, double posY) {
  const baseStats = {
    UnitType.cavalry: (attack: 80.0, defense: 0.2, speed: 60.0),
    UnitType.spear: (attack: 60.0, defense: 0.3, speed: 40.0),
    UnitType.archer: (attack: 70.0, defense: 0.15, speed: 35.0),
    UnitType.musket: (attack: 100.0, defense: 0.1, speed: 30.0),
  };

  final stats = baseStats[type]!;
  return Unit(
    id: id,
    name: name,
    maxStrength: strength.toDouble(),
    attack: stats.attack,
    defense: stats.defense,
    morale: 80.0,
    speed: stats.speed,
    type: type,
    posX: posX,
    posY: posY,
  );
}
