import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Label, score, and a 1–10 [Slider] with colored active track.
class EditableReviewCriterionBar extends StatelessWidget {
  const EditableReviewCriterionBar({
    super.key,
    required this.label,
    required this.value,
    required this.fillColor,
    required this.onChanged,
  });

  final String label;
  final int value;
  final Color fillColor;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    final labelStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w500,
      color: AppColors.splashTitle,
    );
    final scoreStyle = Theme.of(context).textTheme.bodyMedium?.copyWith(
      fontSize: 14,
      fontWeight: FontWeight.w600,
      color: AppColors.textSecondary,
    );

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Row(
          children: [
            Expanded(child: Text(label, style: labelStyle)),
            Text('$value/10', style: scoreStyle),
          ],
        ),
        const SizedBox(height: 4),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            trackHeight: 8,
            activeTrackColor: fillColor,
            inactiveTrackColor: AppColors.borderLight.withValues(alpha: 0.5),
            thumbColor: AppColors.surface,
            overlayShape: SliderComponentShape.noOverlay,
            thumbShape: _OutlinedThumbShape(outlineColor: fillColor, radius: 9),
          ),
          child: Slider(
            value: value.toDouble(),
            min: 1,
            max: 10,
            divisions: 9,
            onChanged: (v) => onChanged(v.round()),
          ),
        ),
      ],
    );
  }
}

class _OutlinedThumbShape extends SliderComponentShape {
  const _OutlinedThumbShape({required this.outlineColor, required this.radius});

  final Color outlineColor;
  final double radius;

  @override
  Size getPreferredSize(bool isEnabled, bool isDiscrete) {
    return Size.fromRadius(radius);
  }

  @override
  void paint(
    PaintingContext context,
    Offset center, {
    required Animation<double> activationAnimation,
    required Animation<double> enableAnimation,
    required bool isDiscrete,
    required TextPainter labelPainter,
    required RenderBox parentBox,
    required SliderThemeData sliderTheme,
    required TextDirection textDirection,
    required double value,
    required double textScaleFactor,
    required Size sizeWithOverflow,
  }) {
    final Canvas canvas = context.canvas;
    final Paint fill = Paint()..color = Colors.white;
    final Paint border = Paint()
      ..color = outlineColor
      ..style = PaintingStyle.stroke
      ..strokeWidth = 2;
    canvas.drawCircle(center, radius, fill);
    canvas.drawCircle(center, radius, border);
  }
}
