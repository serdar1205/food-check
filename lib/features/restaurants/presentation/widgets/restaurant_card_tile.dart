import 'package:flutter/material.dart';

import '../../../../core/constants/restaurant_list_ui_constants.dart';
import '../../../../core/theme/app_colors.dart';
import '../../domain/restaurant.dart';
import 'restaurant_rating_stars.dart';

class RestaurantCardTile extends StatelessWidget {
  const RestaurantCardTile({
    super.key,
    required this.restaurant,
    required this.onTap,
  });

  final Restaurant restaurant;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final nameStyle = Theme.of(context).textTheme.titleMedium?.copyWith(
      fontWeight: FontWeight.bold,
      fontSize: 16,
      color: AppColors.splashTitle,
    );
    final metaStyle = Theme.of(context).textTheme.bodySmall?.copyWith(
      fontSize: 12,
      color: AppColors.textSecondary,
      height: 1.35,
    );

    return Padding(
      padding: const EdgeInsets.only(
        bottom: RestaurantListUiConstants.cardMarginBottom,
      ),
      child: Material(
        color: AppColors.surface,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            RestaurantListUiConstants.cardRadius,
          ),
          side: const BorderSide(color: AppColors.borderLight),
        ),
        clipBehavior: Clip.antiAlias,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(12),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                _RestaurantAvatar(imageUrl: restaurant.imageUrl),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(restaurant.name, style: nameStyle, maxLines: 2),
                      const SizedBox(height: 4),
                      Text(restaurant.address, style: metaStyle, maxLines: 1),
                      const SizedBox(height: 2),
                      Text(restaurant.cuisine, style: metaStyle, maxLines: 1),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    RestaurantRatingStars(rating: restaurant.rating),
                    const SizedBox(height: 4),
                    Text(
                      '${restaurant.rating.toStringAsFixed(1)}/5',
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        fontSize: 11,
                        color: AppColors.textSecondary,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Icon(
                      Icons.chevron_right_rounded,
                      color: AppColors.textSecondary,
                      size: 22,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class _RestaurantAvatar extends StatelessWidget {
  const _RestaurantAvatar({required this.imageUrl});

  final String imageUrl;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      radius: RestaurantListUiConstants.avatarRadius,
      backgroundColor: AppColors.borderLight,
      child: ClipOval(
        child: Image.network(
          imageUrl,
          width: RestaurantListUiConstants.avatarRadius * 2,
          height: RestaurantListUiConstants.avatarRadius * 2,
          fit: BoxFit.cover,
          loadingBuilder: (context, child, loadingProgress) {
            if (loadingProgress == null) {
              return child;
            }
            return Center(
              child: SizedBox(
                width: 20,
                height: 20,
                child: CircularProgressIndicator(
                  strokeWidth: 2,
                  color: AppColors.authAccentYellow.withValues(alpha: 0.7),
                ),
              ),
            );
          },
          errorBuilder: (context, error, stackTrace) {
            return Icon(
              Icons.restaurant_rounded,
              color: AppColors.textSecondary,
              size: 26,
            );
          },
        ),
      ),
    );
  }
}
