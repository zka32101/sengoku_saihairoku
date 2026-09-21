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
    _drawAtmosphericHaze(canvas);
    _drawVignette(canvas);
  }

  /// 奥（画面上部）ほど霞んで見える大気遠近感
  void _drawAtmosphericHaze(Canvas canvas) {
    final hazePaint = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.center,
        colors: [
          Colors.white.withValues(alpha: 0.10),
          Colors.white.withValues(alpha: 0.0),
        ],
      ).createShader(Rect.fromLTWH(0, 0, 360, 640));
    canvas.drawRect(Rect.fromLTWH(0, 0, 360, 260), hazePaint);
  }

  /// 画面端を暗くして臨場感・没入感を高めるビネット
  void _drawVignette(Canvas canvas) {
    final vignettePaint = Paint()
      ..shader = RadialGradient(
        center: Alignment.center,
        radius: 0.95,
        colors: [
          Colors.black.withValues(alpha: 0),
          Colors.black.withValues(alpha: 0.35),
        ],
        stops: const [0.6, 1.0],
      ).createShader(Rect.fromLTWH(0, 0, 360, 640));
    canvas.drawRect(Rect.fromLTWH(0, 0, 360, 640), vignettePaint);
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

  // 地面に対する「押しつぶし率」：真円ではなく縦に潰した楕円にすることで
  // 見下ろし視点に高さのある立体を置いたような2.5D的な見え方にする
  static const _groundSquash = 0.55;

  void _drawHill(Canvas canvas, double cx, double cy, double r) {
    final footprint =
        Rect.fromCenter(center: Offset(cx, cy), width: r * 2, height: r * 2 * _groundSquash);

    // 接地影：楕円の足元にさらに伸びた影を落として高さを演出
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.4)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 6);
    canvas.drawOval(footprint.shift(const Offset(2, 4)), shadowPaint);

    // 外輪郭：グラデーション（楕円の足元）
    final outerPaint = Paint()
      ..shader = RadialGradient(
        center: Alignment(cx / 180 - 1, cy / 320 - 1),
        radius: 1,
        colors: [
          const Color(0xFF3A4A2A),
          const Color(0xFF1A2A0A),
        ],
      ).createShader(footprint);
    canvas.drawOval(footprint, outerPaint);

    // 稜線ドーム：足元より一回り小さく、上にずらした楕円で「盛り上がり」を表現
    final domeRect = Rect.fromCenter(
      center: Offset(cx, cy - r * 0.25),
      width: r * 1.5,
      height: r * 1.5 * _groundSquash,
    );
    canvas.drawOval(domeRect, Paint()..color = const Color(0xFF4A5A3A));

    // 内側のハイライト（左上から光が当たっている稜線）
    final highlightPaint = Paint()
      ..color = const Color(0xFF5F7A4A).withValues(alpha: 0.7)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 3);
    canvas.drawOval(
      Rect.fromCenter(
        center: Offset(cx - r * 0.25, cy - r * 0.45),
        width: r * 0.9,
        height: r * 0.9 * _groundSquash,
      ),
      highlightPaint,
    );
  }

  void _drawForest(Canvas canvas, double cx, double cy, double r) {
    final footprint =
        Rect.fromCenter(center: Offset(cx, cy), width: r * 2, height: r * 2 * _groundSquash);

    // 接地影
    final shadowPaint = Paint()
      ..color = Colors.black.withValues(alpha: 0.3)
      ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4);
    canvas.drawOval(footprint.shift(const Offset(1, 3)), shadowPaint);

    // 外側：濃い森（足元の楕円）
    final outerPaint = Paint()
      ..shader = RadialGradient(
        colors: [
          const Color(0xFF2A4A0A),
          const Color(0xFF0A2A00),
        ],
      ).createShader(footprint);
    canvas.drawOval(footprint, outerPaint);

    // 樹冠：足元より高い位置にドーム状に重ねて木立の高さを演出
    final canopyRect = Rect.fromCenter(
      center: Offset(cx, cy - r * 0.35),
      width: r * 1.4,
      height: r * 1.4 * _groundSquash,
    );
    canvas.drawOval(canopyRect, Paint()..color = const Color(0xFF1A3A0A));

    // 樹の質感：3つの小さな樹冠で立体感（それぞれわずかに高さをずらす）
    final treePaint = Paint()
      ..color = const Color(0xFF0A2A00).withValues(alpha: 0.5);
    for (int i = 0; i < 3; i++) {
      final angle = (i * 120) * pi / 180;
      final dist = r * 0.4;
      final tx = cx + dist * cos(angle);
      final ty = cy - r * 0.3 + dist * sin(angle) * _groundSquash;
      canvas.drawCircle(Offset(tx, ty), r * 0.28, treePaint);
    }

    // 頂点ハイライト
    canvas.drawCircle(
      Offset(cx - r * 0.15, cy - r * 0.5),
      r * 0.22,
      Paint()..color = const Color(0xFF3A5A1A).withValues(alpha: 0.6),
    );
  }

  void _drawBuilding(Canvas canvas, double x, double y, double w, double h) {
    // 接地影
    canvas.drawRect(
      Rect.fromLTWH(x - 1, y + h - 4, w + 6, 10),
      Paint()
        ..color = Colors.black.withValues(alpha: 0.35)
        ..maskFilter = const MaskFilter.blur(BlurStyle.normal, 4),
    );

    // 屋根（奥行きを持たせた台形で建物の高さを表現）
    final roofDepth = h * 0.35;
    final roofPath = Path()
      ..moveTo(x - 4, y)
      ..lineTo(x + w + 4, y)
      ..lineTo(x + w - 6, y - roofDepth)
      ..lineTo(x + 6, y - roofDepth)
      ..close();
    canvas.drawPath(roofPath, Paint()..color = const Color(0xFF6B3A14));
    canvas.drawPath(
      roofPath,
      Paint()
        ..color = const Color(0xFF8B6914)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.5,
    );

    // 壁面（グラデーションで左右の陰影）
    final wallRect = Rect.fromLTWH(x, y, w, h);
    canvas.drawRect(
      wallRect,
      Paint()
        ..shader = LinearGradient(
          colors: [const Color(0xFF5A340F), const Color(0xFF3A1E08)],
        ).createShader(wallRect),
    );
    canvas.drawRect(
      wallRect,
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
