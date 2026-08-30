import 'dart:math';
import 'package:flame/components.dart';
import 'package:flutter/material.dart';
import '../../data/models/scenario_data.dart';

class MapBackground extends PositionComponent {
  final Scenario scenario;

  MapBackground({required this.scenario}) : super(position: Vector2.zero());

  @override
  void render(Canvas canvas) {
    _drawBase(canvas);
    _drawTerrain(canvas);
    _drawBorderLines(canvas);
  }

  void _drawBase(Canvas canvas) {
    // グラデーション背景：空→地面
    final basePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          const Color(0xFF0A1A0A),
          const Color(0xFF0A0A00),
        ],
      ).createShader(Rect.fromLTWH(0, 0, 360, 640));
    canvas.drawRect(Rect.fromLTWH(0, 0, 360, 640), basePaint);

    // 奥行き層：上部は薄く、下部は濃く
    final depthPaint = Paint()
      ..shader = RadialGradient(
        center: const Alignment(0, -0.3),
        radius: 1.2,
        colors: [
          Colors.black.withValues(alpha: 0),
          Colors.black.withValues(alpha: 0.3),
        ],
      ).createShader(Rect.fromLTWH(0, 0, 360, 640));
    canvas.drawRect(Rect.fromLTWH(0, 0, 360, 640), depthPaint);
  }

  void _drawTerrain(Canvas canvas) {
    switch (scenario) {
      case Scenario.odigahara:
        _drawOdigahara(canvas);
      case Scenario.nagashino:
        _drawNagashino(canvas);
      case Scenario.honnoJi:
        _drawHonnoji(canvas);
      case Scenario.sekigahara:
        _drawSekigahara(canvas);
      case Scenario.kawanakajima:
        _drawKawanakajima(canvas);
    }
  }

  void _drawOdigahara(Canvas canvas) {
    // 峠（中央の丘）
    _drawHill(canvas, 160, 290, 60);
    // 森
    _drawForest(canvas, 40, 200, 50);
    _drawForest(canvas, 260, 180, 40);
    // テキスト：峠
    _drawLabel(canvas, '峠', 165, 300, const Color(0xFFAA8844));
  }

  void _drawNagashino(Canvas canvas) {
    // 長篠川（横断する河川）
    final riverPaint = Paint()..color = const Color(0xFF1A4A6A);
    canvas.drawRect(Rect.fromLTWH(0, 300, 360, 20), riverPaint);
    _drawLabel(canvas, '設楽原川', 130, 305, const Color(0xFF64B5F6));
    // 馬防柵エリア
    _drawBarricade(canvas, 50, 270, 260);
  }

  void _drawHonnoji(Canvas canvas) {
    // 本能寺（中央）
    _drawBuilding(canvas, 160, 290, 40, 40);
    _drawLabel(canvas, '本能寺', 148, 300, const Color(0xFFFF6644));
    // 包囲の矢印を省略（テキスト表示）
    _drawLabel(canvas, '明智軍包囲', 100, 200, const Color(0xFF8888FF));
  }

  void _drawSekigahara(Canvas canvas) {
    // 山地（東西）
    _drawHill(canvas, 30, 320, 80);
    _drawHill(canvas, 280, 320, 80);
    // 中央平野
    final plainPaint = Paint()..color = const Color(0xFF152515);
    canvas.drawRect(Rect.fromLTWH(80, 250, 200, 140), plainPaint);
    _drawLabel(canvas, '関ヶ原', 150, 320, const Color(0xFFAAAAAA));
  }

  void _drawKawanakajima(Canvas canvas) {
    // 千曲川と犀川の合流点（川中島の平野）
    final riverPaint = Paint()..color = const Color(0xFF1A4A6A);
    canvas.drawRect(Rect.fromLTWH(0, 60, 360, 16), riverPaint);
    canvas.drawRect(Rect.fromLTWH(0, 500, 360, 16), riverPaint);
    _drawLabel(canvas, '犀川', 160, 62, const Color(0xFF64B5F6));
    _drawLabel(canvas, '千曲川', 155, 502, const Color(0xFF64B5F6));
    // 夜明けの霧（車懸りの奇襲を示す薄い白霧）
    final mistPaint = Paint()
      ..color = Colors.white.withValues(alpha: 0.08)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 20);
    canvas.drawRect(Rect.fromLTWH(0, 150, 360, 340), mistPaint);
    _drawLabel(canvas, '八幡原', 150, 300, const Color(0xFFAAAAAA));
  }

  void _drawHill(Canvas canvas, double cx, double cy, double r) {
    // 影
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawCircle(Offset(cx, cy + 2), r, shadowPaint);

    // 外輪郭：グラデーション
    final outerRect = Rect.fromCircle(center: Offset(cx, cy), radius: r);
    final outerPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment(cx / 180 - 1, cy / 320 - 1),
        radius: 1,
        colors: [
          const Color(0xFF3A4A2A),
          const Color(0xFF1A2A0A),
        ],
      ).createShader(outerRect);
    canvas.drawCircle(Offset(cx, cy), r, outerPaint);

    // 内側のハイライト（左上から光）
    final highlightPaint = Paint()
      ..color = const Color(0xFF4A5A3A).withValues(alpha: 0.6)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawCircle(Offset(cx - r * 0.3, cy - r * 0.3), r * 0.5, highlightPaint);

    // 中央の明るい部分
    canvas.drawCircle(
      Offset(cx, cy),
      r * 0.6,
      Paint()..color = const Color(0xFF4A5A3A),
    );
  }

  void _drawForest(Canvas canvas, double cx, double cy, double r) {
    // 影
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawCircle(Offset(cx, cy + 1), r, shadowPaint);

    // 外側：濃い森
    final outerPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF2A4A0A),
          const Color(0xFF0A2A00),
        ],
      ).createShader(Rect.fromCircle(center: Offset(cx, cy), radius: r));
    canvas.drawCircle(Offset(cx, cy), r, outerPaint);

    // 内側：明るい部分
    canvas.drawCircle(
      Offset(cx, cy),
      r * 0.7,
      Paint()..color = const Color(0xFF1A3A0A),
    );

    // 樹の質感：3つの小さな円で立体感
    final treePaint = Paint()
      ..color = const Color(0xFF0A2A00).withValues(alpha: 0.5);
    for (int i = 0; i < 3; i++) {
      final angle = (i * 120) * pi / 180;
      final dist = r * 0.4;
      final tx = cx + dist * cos(angle);
      final ty = cy + dist * sin(angle);
      canvas.drawCircle(Offset(tx, ty), r * 0.3, treePaint);
    }
  }

  void _drawBuilding(Canvas canvas, double x, double y, double w, double h) {
    canvas.drawRect(
      Rect.fromLTWH(x, y, w, h),
      Paint()..color = const Color(0xFF4A2A0A),
    );
    canvas.drawRect(
      Rect.fromLTWH(x, y, w, h),
      Paint()
        ..color = const Color(0xFF8B6914)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2,
    );
  }

  void _drawBarricade(Canvas canvas, double startX, double y, double endX) {
    final paint = Paint()
      ..color = const Color(0xFF8B6914)
      ..strokeWidth = 3;
    double x = startX;
    while (x < endX) {
      canvas.drawLine(Offset(x, y), Offset(x, y + 10), paint);
      x += 8;
    }
  }

  void _drawLabel(Canvas canvas, String text, double x, double y, Color color) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: color,
          fontSize: 11,
          fontWeight: FontWeight.bold,
        ),
      ),
      textDirection: TextDirection.ltr,
    )..layout();
    textPainter.paint(canvas, Offset(x, y));
  }

  void _drawBorderLines(Canvas canvas) {
    final paint = Paint()
      ..color = const Color(0xFF1A2A1A)
      ..strokeWidth = 0.5;
    for (int i = 1; i < 5; i++) {
      final y = 640.0 * i / 5;
      canvas.drawLine(Offset(0, y), Offset(360, y), paint);
    }
  }

}
