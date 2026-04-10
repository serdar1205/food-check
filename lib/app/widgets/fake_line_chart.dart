import 'dart:math' as math;

import 'package:flutter/material.dart';

import '../../core/theme/app_colors.dart';
import '../../core/theme/partner_theme.dart';

class FakeLineChart extends StatelessWidget {
  const FakeLineChart({
    super.key,
    required this.points,
    this.lineColor = PartnerTheme.accent,
    this.xLabels,
  });

  final List<double> points;
  final Color lineColor;
  final List<String>? xLabels;

  @override
  Widget build(BuildContext context) {
    if (points.length < 2) {
      return const SizedBox.shrink();
    }
    final labels = (xLabels != null && xLabels!.length == points.length)
        ? xLabels!
        : List<String>.generate(points.length, (i) => 'T${i + 1}');
    return Column(
      children: [
        Expanded(
          child: CustomPaint(
            painter: _FakeLineChartPainter(
              points: points,
              lineColor: lineColor,
            ),
            child: const SizedBox.expand(),
          ),
        ),
        const SizedBox(height: 6),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: labels
              .map(
                (label) => Expanded(
                  child: Text(
                    label,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 10,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }
}

class _FakeLineChartPainter extends CustomPainter {
  _FakeLineChartPainter({required this.points, required this.lineColor});

  final List<double> points;
  final Color lineColor;

  @override
  void paint(Canvas canvas, Size size) {
    final chartHeight = size.height;
    final grid = Paint()
      ..color = AppColors.borderLight
      ..strokeWidth = 1;

    for (var i = 1; i <= 3; i++) {
      final y = (chartHeight / 4) * i;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), grid);
    }

    final minV = points.reduce(math.min);
    final maxV = points.reduce(math.max);
    final span = (maxV - minV).abs() < 0.0001 ? 1.0 : maxV - minV;

    final path = Path();
    for (var i = 0; i < points.length; i++) {
      final x = (size.width / (points.length - 1)) * i;
      final norm = (points[i] - minV) / span;
      final y = chartHeight - (norm * (chartHeight - 10)) - 5;
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    final fillPath = Path.from(path)
      ..lineTo(size.width, chartHeight)
      ..lineTo(0, chartHeight)
      ..close();

    final fillPaint = Paint()
      ..shader = LinearGradient(
        colors: [
          lineColor.withValues(alpha: 0.22),
          lineColor.withValues(alpha: 0.02),
        ],
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
      ).createShader(Offset.zero & size);
    canvas.drawPath(fillPath, fillPaint);

    final linePaint = Paint()
      ..color = lineColor
      ..strokeWidth = 2.5
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round
      ..strokeJoin = StrokeJoin.round;
    canvas.drawPath(path, linePaint);

    // Highlight min/max points so the trend is easier to read.
    var minIndex = 0;
    var maxIndex = 0;
    for (var i = 1; i < points.length; i++) {
      if (points[i] < points[minIndex]) {
        minIndex = i;
      }
      if (points[i] > points[maxIndex]) {
        maxIndex = i;
      }
    }

    Offset pointOffset(int index) {
      final x = (size.width / (points.length - 1)) * index;
      final norm = (points[index] - minV) / span;
      final y = chartHeight - (norm * (chartHeight - 10)) - 5;
      return Offset(x, y);
    }

    final markerFill = Paint()..color = AppColors.surface;
    final markerStroke = Paint()
      ..color = lineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;

    void drawMarker(String text, Offset p) {
      canvas.drawCircle(p, 4.5, markerFill);
      canvas.drawCircle(p, 4.5, markerStroke);

      final tp = TextPainter(
        text: TextSpan(
          text: text,
          style: const TextStyle(
            fontSize: 10,
            color: AppColors.textSecondary,
            fontWeight: FontWeight.w600,
          ),
        ),
        textDirection: TextDirection.ltr,
      )..layout();
      final dx = (p.dx + 6).clamp(0.0, math.max(0.0, size.width - tp.width)).toDouble();
      final dy = (p.dy - tp.height - 6).clamp(0.0, chartHeight - tp.height).toDouble();
      tp.paint(canvas, Offset(dx, dy));
    }

    drawMarker(
      'min ${points[minIndex].toStringAsFixed(1)}',
      pointOffset(minIndex),
    );
    drawMarker(
      'max ${points[maxIndex].toStringAsFixed(1)}',
      pointOffset(maxIndex),
    );
  }

  @override
  bool shouldRepaint(covariant _FakeLineChartPainter oldDelegate) {
    return oldDelegate.points != points || oldDelegate.lineColor != lineColor;
  }
}
