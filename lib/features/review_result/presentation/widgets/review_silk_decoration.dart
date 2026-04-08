import 'package:flutter/material.dart';

import '../../../../core/theme/review_result_colors.dart';

/// Abstract golden wave strip (no asset) to echo the reference silk image.
class ReviewSilkDecoration extends StatelessWidget {
  const ReviewSilkDecoration({super.key});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: SizedBox(
        height: 112,
        width: double.infinity,
        child: CustomPaint(painter: _SilkWavePainter()),
      ),
    );
  }
}

class _SilkWavePainter extends CustomPainter {
  @override
  void paint(Canvas canvas, Size size) {
    final rect = Offset.zero & size;
    final base = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
        colors: [
          const Color(0xFF8B6914).withValues(alpha: 0.85),
          ReviewResultColors.actionGold.withValues(alpha: 0.9),
          const Color(0xFF5C4A1A).withValues(alpha: 0.75),
          const Color(0xFFB8860B).withValues(alpha: 0.8),
        ],
        stops: const [0.0, 0.35, 0.65, 1.0],
      ).createShader(rect);

    canvas.drawRect(rect, base);

    final highlight = Paint()
      ..shader = LinearGradient(
        begin: Alignment.topCenter,
        end: Alignment.bottomCenter,
        colors: [
          Colors.white.withValues(alpha: 0.35),
          Colors.transparent,
          Colors.black.withValues(alpha: 0.12),
        ],
      ).createShader(rect);

    final path = Path();
    path.moveTo(0, size.height * 0.55);
    for (var i = 0; i <= 6; i++) {
      final t = i / 6;
      final x = size.width * t;
      final y =
          size.height * 0.45 +
          size.height * 0.12 * (i.isEven ? 1 : -1) * (0.5 + 0.5 * t);
      path.lineTo(x, y);
    }
    path.lineTo(size.width, size.height);
    path.lineTo(0, size.height);
    path.close();
    canvas.drawPath(path, highlight);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}
