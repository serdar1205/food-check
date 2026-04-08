import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';

/// Five-star row for [rating] in 0–5 (supports half stars).
class RestaurantRatingStars extends StatelessWidget {
  const RestaurantRatingStars({
    super.key,
    required this.rating,
    this.starSize = 14,
  });

  final double rating;
  final double starSize;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: List<Widget>.generate(5, (int index) {
        final int starIndex = index + 1;
        final bool filled = rating >= starIndex;
        final bool half = !filled && rating >= starIndex - 0.5;
        final IconData icon = filled
            ? Icons.star_rounded
            : half
            ? Icons.star_half_rounded
            : Icons.star_border_rounded;
        final Color color = filled || half
            ? AppColors.brandYellow
            : AppColors.borderLight;
        return Icon(icon, size: starSize, color: color);
      }),
    );
  }
}
