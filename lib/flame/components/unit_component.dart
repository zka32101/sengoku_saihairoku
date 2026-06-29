import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../domain/combat/unit.dart';

enum UnitEffectType { hit, death }

class UnitComponent extends PositionComponent {
  final Unit unit;
  final bool isPlayer;
  final void Function(Vector2 pos, UnitEffectType type)? onEffect;

  static const _halfSize = 10.0;
  static const _fullSize = _halfSize * 2;
  static const _hpBarHeight = 4.0;
  static const _hpBarOffsetY = 14.0;

  bool _wasColliding = false;
  bool _wasDead = false;

  UnitComponent({
    required this.unit,
    required this.isPlayer,
    this.onEffect,
  }) : super(anchor: Anchor.center);

  @override
  void update(double dt) {
    super.update(dt);
    position = Vector2(unit.posX, unit.posY);

    final nowColliding = unit.isColliding;
    final nowDead = unit.isDead;

    // 衝突開始 → ヒットエフェクト
    if (!_wasColliding && nowColliding && !nowDead) {
      onEffect?.call(position.clone(), UnitEffectType.hit);
    }
    // 死亡 → 爆発エフェクト
    if (!_wasDead && nowDead) {
      onEffect?.call(position.clone(), UnitEffectType.death);
      removeFromParent();
    }

    _wasColliding = nowColliding;
    _wasDead = nowDead;
  }

  @override
  void render(Canvas canvas) {
    if (unit.isDead) return;

    final ratio = unit.strengthRatio;
    final fill = unit.isColliding
        ? Colors.white.withValues(alpha: 0.9)
        : _baseColor.withValues(alpha: 0.85);

    _drawBody(canvas, fill);
    _drawHealthBar(canvas, ratio);
    _drawIcon(canvas);
  }

  void _drawBody(Canvas canvas, Color fill) {
    final borderColor = isPlayer ? const Color(0xFFFFD700) : const Color(0xFFAA4444);

    // 影
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(const Offset(1, 2), _halfSize + 2, shadowPaint);

    // グロー
    final glowPaint = Paint()
      ..color = borderColor.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(Offset.zero, _halfSize + 3, glowPaint);

    final bodyPaint = Paint()..color = fill;
    final borderPaint = Paint()
      ..color = borderColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    switch (unit.type) {
      case UnitType.cavalry:
        final path = Path()
          ..moveTo(0, -_halfSize)
          ..lineTo(_halfSize, 0)
          ..lineTo(0, _halfSize)
          ..lineTo(-_halfSize, 0)
          ..close();
        canvas.drawPath(path, bodyPaint);
        canvas.drawPath(path, borderPaint);
      case UnitType.archer:
        final path = Path()
          ..moveTo(0, -_halfSize)
          ..lineTo(_halfSize, _halfSize)
          ..lineTo(-_halfSize, _halfSize)
          ..close();
        canvas.drawPath(path, bodyPaint);
        canvas.drawPath(path, borderPaint);
      case UnitType.spear:
        canvas.drawCircle(Offset.zero, _halfSize, bodyPaint);
        canvas.drawCircle(Offset.zero, _halfSize, borderPaint);
      case UnitType.musket:
        const r = Rect.fromLTRB(
            -_halfSize + 1, -_halfSize + 1, _halfSize - 1, _halfSize - 1);
        canvas.drawRect(r, bodyPaint);
        canvas.drawRect(r, borderPaint);
    }

    // 内部ハイライト
    final highlightPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.2)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
    canvas.drawCircle(Offset(-_halfSize * 0.3, -_halfSize * 0.3), _halfSize * 0.4, highlightPaint);
  }

  void _drawHealthBar(Canvas canvas, double ratio) {
    final barTop = _halfSize + _hpBarOffsetY;

    // バー背景（暗い）
    final bgPaint = Paint()
      ..color = const Color(0xFF1A1A1A)
      ..style = PaintingStyle.fill;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(-_halfSize, barTop, _fullSize, _hpBarHeight),
        const Radius.circular(2),
      ),
      bgPaint,
    );

    // バー枠線
    final borderPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.6)
      ..style = PaintingStyle.stroke
      ..strokeWidth = 0.5;
    canvas.drawRRect(
      RRect.fromRectAndRadius(
        Rect.fromLTWH(-_halfSize, barTop, _fullSize, _hpBarHeight),
        const Radius.circular(2),
      ),
      borderPaint,
    );

    final hpColor = ratio > 0.6
        ? const Color(0xFF44FF44)
        : ratio > 0.3
            ? const Color(0xFFFFAA00)
            : const Color(0xFFFF3333);

    // グラデーション HP バー
    final filledRect = Rect.fromLTWH(-_halfSize, barTop, _fullSize * ratio, _hpBarHeight);
    final hpPaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          hpColor.withValues(alpha: 0.9),
          hpColor,
        ],
      ).createShader(filledRect)
      ..style = PaintingStyle.fill;

    canvas.drawRRect(
      RRect.fromRectAndRadius(
        filledRect,
        const Radius.circular(1.5),
      ),
      hpPaint,
    );

    // HP バーグロー
    if (ratio < 0.3) {
      final glowPaint = Paint()
        ..color = hpColor.withValues(alpha: 0.3)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 2);
      canvas.drawRRect(
        RRect.fromRectAndRadius(
          Rect.fromLTWH(-_halfSize - 1, barTop - 1, _fullSize * ratio + 2, _hpBarHeight + 2),
          const Radius.circular(2.5),
        ),
        glowPaint,
      );
    }
  }

  void _drawIcon(Canvas canvas) {
    final icon = switch (unit.type) {
      UnitType.cavalry => '馬',
      UnitType.archer => '弓',
      UnitType.spear => '槍',
      UnitType.musket => '鉄',
    };

    final painter = TextPainter(
      text: TextSpan(
        text: icon,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 8,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();

    painter.paint(canvas, Offset(-painter.width / 2, -painter.height / 2));
  }

  Color get _baseColor => isPlayer
      ? switch (unit.type) {
          UnitType.cavalry => const Color(0xFF2244AA),
          UnitType.archer => const Color(0xFF225588),
          UnitType.spear => const Color(0xFF1A3377),
          UnitType.musket => const Color(0xFF334499),
        }
      : switch (unit.type) {
          UnitType.cavalry => const Color(0xFFAA2222),
          UnitType.archer => const Color(0xFF882222),
          UnitType.spear => const Color(0xFF771A1A),
          UnitType.musket => const Color(0xFF993333),
        };
}
