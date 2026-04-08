import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/router.dart';
import '../../../core/application/request_status.dart';
import '../../../core/constants/venue_details_ui_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/venue_theme.dart';
import '../../restaurants/application/venue_details_cubit.dart';
import '../../restaurants/domain/restaurant.dart';
import '../../restaurants/presentation/widgets/restaurant_rating_stars.dart';
import 'widgets/venue_criteria_bar.dart';
import 'widgets/venue_detail_app_bar.dart';

class VenueDetailsPage extends StatefulWidget {
  const VenueDetailsPage({super.key});

  @override
  State<VenueDetailsPage> createState() => _VenueDetailsPageState();
}

class _VenueDetailsPageState extends State<VenueDetailsPage> {
  @override
  void initState() {
    super.initState();
    context.read<VenueDetailsCubit>().load();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<VenueDetailsCubit, VenueDetailsState>(
      builder: (context, state) {
        if (state.status == RequestStatus.loading) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: const VenueDetailAppBar(),
            body: const Center(
              child: CircularProgressIndicator(
                color: AppColors.authAccentYellow,
              ),
            ),
          );
        }
        if (state.status == RequestStatus.failure) {
          return Scaffold(
            backgroundColor: AppColors.background,
            appBar: const VenueDetailAppBar(),
            body: Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Text(
                  state.message ?? 'Ошибка',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: AppColors.textSecondary,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
          );
        }
        final restaurant = state.restaurant;
        if (restaurant == null) {
          return const Scaffold(body: SizedBox.shrink());
        }
        return _VenueDetailsBody(restaurant: restaurant);
      },
    );
  }
}

class _VenueDetailsBody extends StatelessWidget {
  const _VenueDetailsBody({required this.restaurant});

  final Restaurant restaurant;

  void _openReviewFlow(BuildContext context) {
    Navigator.of(context).pushNamed(AppRoutes.review, arguments: restaurant.id);
  }

  @override
  Widget build(BuildContext context) {
    final caption = _ratingCaption(restaurant.rating);
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: const VenueDetailAppBar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(
          VenueDetailsUiConstants.screenPadding,
          8,
          VenueDetailsUiConstants.screenPadding,
          24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            _VenueSummaryCard(
              restaurant: restaurant,
              ratingCaption: caption.$1,
              ratingCaptionColor: caption.$2,
            ),
            const SizedBox(height: 16),
            _VenueCriteriaCard(restaurant: restaurant),
            const SizedBox(height: 28),
            SizedBox(
              height: VenueDetailsUiConstants.primaryButtonHeight,
              child: FilledButton.icon(
                onPressed: () => _openReviewFlow(context),
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.authAccentYellow,
                  foregroundColor: AppColors.textPrimary,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  elevation: 0,
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                icon: const Icon(Icons.edit_note_rounded, size: 24),
                label: const Text('Загрузить чек'),
              ),
            ),
            const SizedBox(height: 12),
            SizedBox(
              height: VenueDetailsUiConstants.primaryButtonHeight,
              child: OutlinedButton.icon(
                onPressed: () => _openReviewFlow(context),
                style: OutlinedButton.styleFrom(
                  foregroundColor: AppColors.textPrimary,
                  side: const BorderSide(color: AppColors.borderLight),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                  textStyle: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                icon: const Icon(Icons.photo_camera_outlined, size: 22),
                label: const Text('Сфотографировать чек'),
              ),
            ),
          ],
        ),
      ),
    );
  }

  static (String, Color) _ratingCaption(double rating) {
    if (rating >= 4.0) {
      return ('Отлично!', VenueRatingCaptionColors.excellent);
    }
    if (rating >= 3.5) {
      return ('Хорошо!', AppColors.authAccentYellow);
    }
    if (rating >= 3.0) {
      return ('Неплохо', AppColors.textSecondary);
    }
    return ('Можно лучше', AppColors.textSecondary);
  }
}

class _VenueSummaryCard extends StatelessWidget {
  const _VenueSummaryCard({
    required this.restaurant,
    required this.ratingCaption,
    required this.ratingCaptionColor,
  });

  final Restaurant restaurant;
  final String ratingCaption;
  final Color ratingCaptionColor;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VenueDetailsUiConstants.cardRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              restaurant.name,
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                fontWeight: FontWeight.bold,
                fontSize: 20,
                color: AppColors.splashTitle,
              ),
            ),
            const SizedBox(height: 6),
            Text(
              restaurant.address,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 16),
            ClipRRect(
              borderRadius: BorderRadius.circular(
                VenueDetailsUiConstants.imageRadius,
              ),
              child: AspectRatio(
                aspectRatio: 1,
                child: Image.network(
                  restaurant.imageUrl,
                  fit: BoxFit.cover,
                  loadingBuilder: (context, child, progress) {
                    if (progress == null) {
                      return child;
                    }
                    return ColoredBox(
                      color: AppColors.borderLight.withValues(alpha: 0.3),
                      child: const Center(
                        child: CircularProgressIndicator(
                          strokeWidth: 2,
                          color: AppColors.authAccentYellow,
                        ),
                      ),
                    );
                  },
                  errorBuilder: (context, error, stack) {
                    return ColoredBox(
                      color: AppColors.borderLight.withValues(alpha: 0.4),
                      child: Icon(
                        Icons.restaurant_rounded,
                        size: 64,
                        color: AppColors.textSecondary,
                      ),
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              'ОБЩАЯ ОЦЕНКА',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            Center(
              child: RestaurantRatingStars(
                rating: restaurant.rating,
                starSize: 28,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              ratingCaption,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: ratingCaptionColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _VenueCriteriaCard extends StatelessWidget {
  const _VenueCriteriaCard({required this.restaurant});

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      elevation: 0,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(VenueDetailsUiConstants.cardRadius),
      ),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            VenueCriteriaBar(
              label: 'Качество еды',
              score: restaurant.foodQualityScore,
              fillColor: VenueCriteriaBarColors.food,
            ),
            const SizedBox(height: 18),
            VenueCriteriaBar(
              label: 'Обслуживание',
              score: restaurant.serviceScore,
              fillColor: VenueCriteriaBarColors.service,
            ),
            const SizedBox(height: 18),
            VenueCriteriaBar(
              label: 'Атмосфера',
              score: restaurant.atmosphereScore,
              fillColor: VenueCriteriaBarColors.atmosphere,
            ),
            const SizedBox(height: 18),
            VenueCriteriaBar(
              label: 'Цена/Качество',
              score: restaurant.priceQualityScore,
              fillColor: VenueCriteriaBarColors.priceQuality,
            ),
          ],
        ),
      ),
    );
  }
}
