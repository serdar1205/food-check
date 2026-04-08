import 'package:flutter/material.dart';

import '../../../../core/constants/reviews_tab_ui_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../restaurants/presentation/widgets/restaurant_rating_stars.dart';
import '../../domain/user_review_summary.dart';

class UserReviewCardTile extends StatelessWidget {
  const UserReviewCardTile({super.key, required this.review, this.onTap});

  final UserReviewSummary review;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final titleStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: AppColors.splashTitle,
    );
    final bodyStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      fontSize: 13,
      color: AppColors.textSecondary,
      height: 1.4,
    );

    return Padding(
      padding: const EdgeInsets.only(
        bottom: ReviewsTabUiConstants.cardMarginBottom,
      ),
      child: Material(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ReviewsTabUiConstants.cardRadius),
          side: const BorderSide(color: AppColors.borderLight),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(14),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      decoration: BoxDecoration(
                        color: AppColors.background,
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        Icons.rate_review_rounded,
                        color: AppColors.authAccentYellow,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            review.restaurantName,
                            style: titleStyle,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(height: 4),
                          Text(review.dateLabel, style: bodyStyle),
                        ],
                      ),
                    ),
                    _PublicationChip(status: review.status),
                  ],
                ),
                const SizedBox(height: 10),
                Row(
                  children: [
                    RestaurantRatingStars(
                      rating: review.overallRating.toDouble(),
                      starSize: 18,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      '${review.overallRating}/5',
                      style: bodyStyle?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 8),
                Text(
                  review.teaser,
                  style: bodyStyle,
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _PublicationChip extends StatelessWidget {
  const _PublicationChip({required this.status});

  final UserReviewPublicationStatus status;

  @override
  Widget build(BuildContext context) {
    final (String label, Color bg, Color fg) = switch (status) {
      UserReviewPublicationStatus.published => (
        'Опубликован',
        const Color(0xFFE8F5E9),
        const Color(0xFF2E7D32),
      ),
      UserReviewPublicationStatus.pendingModeration => (
        'На проверке',
        AppColors.authAccentYellow.withValues(alpha: 0.28),
        AppColors.splashTitle,
      ),
    };

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(fontSize: 11, fontWeight: FontWeight.w600, color: fg),
      ),
    );
  }
}
