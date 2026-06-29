import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';

/// 衝突時フラッシュ（0.4秒）—豪華版
class HitFlashEffect extends PositionComponent {
  final bool isPlayer;
  double _elapsed = 0;
  static const _duration = 0.4;
  static const _count = 12;
  static const _count2 = 8;

  HitFlashEffect({required Vector2 pos, required this.isPlayer})
      : super(anchor: Anchor.center, position: pos);

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;
    if (_elapsed >= _duration) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    final t = (_elapsed / _duration).clamp(0.0, 1.0);
    final alpha = 1.0 - t;
    final color = isPlayer ? const Color(0xFFFF8844) : const Color(0xFF44AAFF);

    // レイヤー1：外側の放射パーティクル
    final spread1 = t * 35;
    for (int i = 0; i < _count; i++) {
      final angle = i * 2 * pi / _count + t * pi;
      final x = cos(angle) * spread1;
      final y = sin(angle) * spread1;
      canvas.drawCircle(
        Offset(x, y),
        (3 * (1 - t)).clamp(0.5, 4.0),
        Paint()..color = color.withValues(alpha: alpha * 0.6),
      );
    }

    // レイヤー2：内側の高速パーティクル
    final spread2 = t * 15;
    for (int i = 0; i < _count2; i++) {
      final angle = i * 2 * pi / _count2 - t * pi * 0.5;
      final x = cos(angle) * spread2;
      final y = sin(angle) * spread2;
      canvas.drawCircle(
        Offset(x, y),
        (5 * (1 - t)).clamp(1.0, 6.0),
        Paint()..color = color.withValues(alpha: alpha),
      );
    }

    // 中央白グロー
    final glowPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          Colors.white.withValues(alpha: alpha * 0.9),
          Colors.white.withValues(alpha: 0),
        ],
      ).createShader(Rect.fromCircle(center: Offset.zero, radius: 15));
    canvas.drawCircle(Offset.zero, 12 * (1 - t), glowPaint);

    // コア：色付き中央
    canvas.drawCircle(
      Offset.zero,
      4 * (1 - t),
      Paint()..color = color.withValues(alpha: alpha),
    );
  }
}

/// ユニット死亡時爆発（0.8秒）—豪華版
class DeathExplosionEffect extends PositionComponent {
  final bool isPlayer;
  double _elapsed = 0;
  static const _duration = 0.8;
  static const _count = 16;
  static const _count2 = 12;

  DeathExplosionEffect({required Vector2 pos, required this.isPlayer})
      : super(anchor: Anchor.center, position: pos);

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;
    if (_elapsed >= _duration) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    final t = (_elapsed / _duration).clamp(0.0, 1.0);
    final alpha = 1.0 - t;

    // 衝撃波リング（3重）
    for (int ring = 0; ring < 3; ring++) {
      final ringT = (t - ring * 0.1).clamp(0.0, 1.0);
      final ringAlpha = (1.0 - ringT) * 0.5;
      final ringSize = ringT * 50 + ring * 5;
      final ringWidth = (3 - ring) * (1 - ringT);
      canvas.drawCircle(
        Offset.zero,
        ringSize,
        Paint()
          ..color = const Color(0xFFFFD700).withValues(alpha: ringAlpha)
          ..style = PaintingStyle.stroke
          ..strokeWidth = ringWidth,
      );
    }

    // 放射パーティクル（多量）
    for (int i = 0; i < _count; i++) {
      final angle = i * 2 * pi / _count;
      final dist = t * 50;
      final size = (6 * (1 - t)).clamp(1.0, 8.0);
      canvas.drawCircle(
        Offset(cos(angle) * dist, sin(angle) * dist),
        size,
        Paint()
          ..color = const Color(0xFFFF6622).withValues(alpha: alpha * 0.8),
      );
    }

    // 高速上昇パーティクル（煙っぽく）
    for (int i = 0; i < _count2; i++) {
      final angle = (i * 2 * pi / _count2) + t * pi;
      final dist = t * 40;
      final y = dist * 0.8 - t * 30; // 上昇する
      canvas.drawCircle(
        Offset(cos(angle) * dist * 0.6, y),
        (4 * (1 - t)).clamp(0.5, 5.0),
        Paint()
          ..color = const Color(0xFFFF8844).withValues(alpha: alpha * 0.5),
      );
    }

    // 中心爆発フラッシュ（最初）
    if (t < 0.4) {
      final flashT = t / 0.4;
      canvas.drawCircle(
        Offset.zero,
        20 * (1 - flashT),
        Paint()
          ..shader = RadialGradient(
            colors: [
              Colors.white.withValues(alpha: (1 - flashT) * 0.9),
              Colors.yellow.withValues(alpha: (1 - flashT) * 0.4),
            ],
          ).createShader(Rect.fromCircle(center: Offset.zero, radius: 20)),
      );
    }
  }
}

/// ターニングポイント達成スパークル（1.2秒）—豪華版
class TpSparkleEffect extends PositionComponent {
  double _elapsed = 0;
  static const _duration = 1.2;
  static const _starCount = 16;
  static const _smallStarCount = 24;

  TpSparkleEffect({required Vector2 pos})
      : super(anchor: Anchor.center, position: pos);

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;
    if (_elapsed >= _duration) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    final t = (_elapsed / _duration).clamp(0.0, 1.0);
    final alpha = t < 0.5 ? t * 2 : (1 - t) * 2;

    // 大きな金星パーティクル（外側）
    for (int i = 0; i < _starCount; i++) {
      final angle = i * 2 * pi / _starCount + t * pi * 1.5;
      final dist = 25 + sin(t * pi) * 40;
      _drawStar(
        canvas,
        Offset(cos(angle) * dist, sin(angle) * dist),
        7 * alpha,
        const Color(0xFFFFD700).withValues(alpha: alpha * 0.9),
      );
    }

    // 小さな星パーティクル（内側、多色）
    for (int i = 0; i < _smallStarCount; i++) {
      final angle = i * 2 * pi / _smallStarCount - t * pi * 0.8;
      final dist = 10 + sin((t + i * 0.1) * pi) * 20;
      final colorIdx = i % 3;
      final starColor = switch (colorIdx) {
        0 => const Color(0xFFFFD700),
        1 => const Color(0xFFFFAA44),
        _ => const Color(0xFFFFFF88),
      };
      _drawStar(
        canvas,
        Offset(cos(angle) * dist, sin(angle) * dist),
        4 * alpha,
        starColor.withValues(alpha: alpha * 0.7),
      );
    }

    // 中心グロー（段階的）
    for (int ring = 0; ring < 3; ring++) {
      final ringT = (1.0 - (t + ring * 0.15)).clamp(0.0, 1.0);
      canvas.drawCircle(
        Offset.zero,
        15 * ringT,
        Paint()
          ..color = const Color(0xFFFFD700)
              .withValues(alpha: alpha * 0.5 * (1 - ring * 0.2)),
      );
    }

    // 中央輝き
    canvas.drawCircle(
      Offset.zero,
      8 * sin(t * pi),
      Paint()
        ..shader = RadialGradient(
          colors: [
            Colors.white.withValues(alpha: alpha * 0.8),
            const Color(0xFFFFD700).withValues(alpha: alpha * 0.3),
          ],
        ).createShader(Rect.fromCircle(center: Offset.zero, radius: 8)),
    );
  }

  void _drawStar(Canvas canvas, Offset center, double r, Color color) {
    if (r <= 0) return;
    final path = Path();
    for (int i = 0; i < 5; i++) {
      final outer = i * 2 * pi / 5 - pi / 2;
      final inner = outer + pi / 5;
      final ox = center.dx + cos(outer) * r;
      final oy = center.dy + sin(outer) * r;
      final ix = center.dx + cos(inner) * r * 0.4;
      final iy = center.dy + sin(inner) * r * 0.4;
      if (i == 0) {
        path.moveTo(ox, oy);
      } else {
        path.lineTo(ox, oy);
      }
      path.lineTo(ix, iy);
    }
    path.close();
    canvas.drawPath(path, Paint()..color = color);
  }
}

/// クリティカルヒット時の特別な光（0.5秒）
class CriticalHitEffect extends PositionComponent {
  double _elapsed = 0;
  static const _duration = 0.5;

  CriticalHitEffect({required Vector2 pos})
      : super(anchor: Anchor.center, position: pos);

  @override
  void update(double dt) {
    super.update(dt);
    _elapsed += dt;
    if (_elapsed >= _duration) removeFromParent();
  }

  @override
  void render(Canvas canvas) {
    final t = (_elapsed / _duration).clamp(0.0, 1.0);
    final alpha = 1.0 - t;

    // 赤と黄色の斬撃エフェクト
    final slashCount = 8;
    for (int i = 0; i < slashCount; i++) {
      final angle = i * 2 * pi / slashCount + t * pi * 2;
      final len = t * 40;
      final startX = cos(angle) * 5;
      final startY = sin(angle) * 5;
      final endX = cos(angle) * (5 + len);
      final endY = sin(angle) * (5 + len);

      // 赤い斬撃
      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX, endY),
        Paint()
          ..color = const Color(0xFFFF3333).withValues(alpha: alpha * 0.8)
          ..strokeWidth = 3 * (1 - t),
      );

      // 黄色の内側
      canvas.drawLine(
        Offset(startX, startY),
        Offset(endX * 0.7, endY * 0.7),
        Paint()
          ..color = const Color(0xFFFFDD00).withValues(alpha: alpha * 0.6)
          ..strokeWidth = 1.5 * (1 - t),
      );
    }

    // 中央の炸裂
    for (int ring = 0; ring < 3; ring++) {
      final ringAlpha = alpha * (1 - ring * 0.3);
      canvas.drawCircle(
        Offset.zero,
        15 * (ring + t * 2),
        Paint()
          ..color = const Color(0xFFFFAA00).withValues(alpha: ringAlpha * 0.5)
          ..style = PaintingStyle.stroke
          ..strokeWidth = 2 * (1 - t),
      );
    }
  }
}
