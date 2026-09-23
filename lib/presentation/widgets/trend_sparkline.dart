import 'package:flutter/material.dart';
import '../../data/models/advanced_statistics.dart';

/// [PerformanceTrend]の時系列データを折れ線グラフで描画するスパークライン
///
/// `winRateTrend`/`scoreTrend`は既に[StatisticsService]で計算済みだが、
/// これまでUI側では[PerformanceTrend.trend]の文言表示のみに使われ、
/// 実際の推移グラフは描画されていなかった。
class TrendSparkline extends StatelessWidget {
  final String label;
  final List<TrendDataPoint> points;
  final Color color;
  final String Function(double) valueFormatter;

  const TrendSparkline({
    super.key,
    required this.label,
    required this.points,
    required this.color,
    required this.valueFormatter,
  });

  @override
  Widget build(BuildContext context) {
    if (points.length < 2) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: 8),
        child: Text(
          '$label: データが不足しています',
          style: TextStyle(fontSize: 12, color: Colors.grey[500]),
        ),
      );
    }

    final latest = points.last.value;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: const TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
            ),
            Text(
              valueFormatter(latest),
              style: TextStyle(
                fontSize: 12,
                fontWeight: FontWeight.bold,
                color: color,
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        SizedBox(
          height: 56,
          width: double.infinity,
          child: CustomPaint(
            painter: _SparklinePainter(points: points, color: color),
          ),
        ),
      ],
    );
  }
}

class _SparklinePainter extends CustomPainter {
  final List<TrendDataPoint> points;
  final Color color;

  _SparklinePainter({required this.points, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final values = points.map((p) => p.value).toList();
    final minValue = values.reduce((a, b) => a < b ? a : b);
    final maxValue = values.reduce((a, b) => a > b ? a : b);
    final range = (maxValue - minValue).abs() < 0.0001
        ? 1.0
        : maxValue - minValue;

    final dx = size.width / (points.length - 1);
    final offsets = <Offset>[];
    for (int i = 0; i < points.length; i++) {
      final normalized = (points[i].value - minValue) / range;
      final y = size.height - (normalized * size.height);
      offsets.add(Offset(i * dx, y));
    }

    final linePaint = Paint()
      ..color = color
      ..strokeWidth = 2
      ..style = PaintingStyle.stroke
      ..strokeJoin = StrokeJoin.round;

    final path = Path()..moveTo(offsets.first.dx, offsets.first.dy);
    for (final offset in offsets.skip(1)) {
      path.lineTo(offset.dx, offset.dy);
    }
    canvas.drawPath(path, linePaint);

    final fillPath = Path.from(path)
      ..lineTo(offsets.last.dx, size.height)
      ..lineTo(offsets.first.dx, size.height)
      ..close();
    canvas.drawPath(
      fillPath,
      Paint()..color = color.withOpacity(0.12),
    );

    final dotPaint = Paint()..color = color;
    canvas.drawCircle(offsets.last, 3, dotPaint);
  }

  @override
  bool shouldRepaint(covariant _SparklinePainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.color != color;
  }
}
