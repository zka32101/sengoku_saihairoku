import 'package:flutter/material.dart';
import '../../domain/combat/unit.dart';

class UnitInfoPanel extends StatelessWidget {
  final Unit? selectedUnit;
  final bool isPlayer;

  const UnitInfoPanel({
    super.key,
    required this.selectedUnit,
    required this.isPlayer,
  });

  @override
  Widget build(BuildContext context) {
    if (selectedUnit == null) {
      return Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF1A0A0A).withValues(alpha: 0.8),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(
            color: const Color(0xFF8B6914).withValues(alpha: 0.3),
            width: 1,
          ),
        ),
        child: const Text(
          'ユニットを選択',
          style: TextStyle(color: Colors.grey, fontSize: 12),
        ),
      );
    }

    final unit = selectedUnit!;
    final hpPercent = (unit.hp / unit.maxHp * 100).toStringAsFixed(0);
    final hpColor = unit.hp > unit.maxHp * 0.6
        ? Colors.green
        : unit.hp > unit.maxHp * 0.3
            ? Colors.orange
            : Colors.red;

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.topCenter,
          end: Alignment.bottomCenter,
          colors: [
            const Color(0xFF2A1A0A).withValues(alpha: 0.9),
            const Color(0xFF1A0A0A).withValues(alpha: 0.95),
          ],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: isPlayer
              ? Colors.red.withValues(alpha: 0.5)
              : Colors.blue.withValues(alpha: 0.5),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: isPlayer
                ? Colors.red.withValues(alpha: 0.2)
                : Colors.blue.withValues(alpha: 0.2),
            blurRadius: 8,
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  unit.name,
                  style: const TextStyle(
                    color: Color(0xFFFFD700),
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
                decoration: BoxDecoration(
                  color: _getTypeColor(unit.type).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(4),
                  border: Border.all(
                    color: _getTypeColor(unit.type),
                    width: 1,
                  ),
                ),
                child: Text(
                  _getTypeLabel(unit.type),
                  style: TextStyle(
                    color: _getTypeColor(unit.type),
                    fontSize: 11,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // HP バー
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'HP',
                    style: TextStyle(color: Colors.grey, fontSize: 11),
                  ),
                  Text(
                    '$hpPercent%',
                    style: TextStyle(
                      color: hpColor,
                      fontSize: 11,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 4),
              ClipRRect(
                borderRadius: BorderRadius.circular(3),
                child: LinearProgressIndicator(
                  value: unit.hp / unit.maxHp,
                  minHeight: 8,
                  backgroundColor: const Color(0xFF1A1A1A),
                  valueColor: AlwaysStoppedAnimation<Color>(hpColor),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          // ステータス情報
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _StatItem('攻撃', unit.attack.toStringAsFixed(0), Colors.orange),
              _StatItem('防御', unit.defense.toStringAsFixed(2), Colors.blue),
              _StatItem('速度', unit.speed.toStringAsFixed(1), Colors.purple),
            ],
          ),
          const SizedBox(height: 8),
          // ステータス表示
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                unit.isColliding ? '🔴 衝突中' : '⚫ 通常',
                style: TextStyle(
                  color: unit.isColliding ? Colors.red : Colors.grey,
                  fontSize: 10,
                ),
              ),
              Text(
                unit.isMoving ? '⬆️ 移動中' : '⏸️ 停止中',
                style: const TextStyle(color: Colors.grey, fontSize: 10),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Color _getTypeColor(UnitType type) => switch (type) {
        UnitType.cavalry => Colors.red,
        UnitType.archer => Colors.green,
        UnitType.spear => Colors.blue,
        UnitType.musket => Colors.orange,
      };

  String _getTypeLabel(UnitType type) => switch (type) {
        UnitType.cavalry => '騎馬',
        UnitType.archer => '弓',
        UnitType.spear => '槍',
        UnitType.musket => '鉄砲',
      };
}

class _StatItem extends StatelessWidget {
  final String label;
  final String value;
  final Color color;

  const _StatItem(this.label, this.value, this.color);

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Text(
          label,
          style: const TextStyle(color: Colors.grey, fontSize: 10),
        ),
        const SizedBox(height: 2),
        Text(
          value,
          style: TextStyle(
            color: color,
            fontSize: 12,
            fontWeight: FontWeight.bold,
          ),
        ),
      ],
    );
  }
}
