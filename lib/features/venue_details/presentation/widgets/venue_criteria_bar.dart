import 'package:flutter/material.dart';

import '../../../../core/constants/venue_details_ui_constants.dart';
import '../../../../core/theme/app_colors.dart';

class VenueCriteriaBar extends StatelessWidget {
  const VenueCriteriaBar({
    super.key,
    required this.label,
    required this.score,
    required this.fillColor,
  });

  final String label;
  final int score;
  final Color fillColor;

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
            Text('$score/10', style: scoreStyle),
          ],
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius: BorderRadius.circular(
            VenueDetailsUiConstants.barTrackRadius,
          ),
          child: LinearProgressIndicator(
            value: score / 10,
            minHeight: VenueDetailsUiConstants.barHeight,
            backgroundColor: AppColors.borderLight.withValues(alpha: 0.45),
            valueColor: AlwaysStoppedAnimation<Color>(fillColor),
          ),
        ),
      ],
    );
  }
}
