import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/di.dart';
import '../../../app/router.dart';
import '../../../core/constants/review_form_ui_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/venue_theme.dart';
import '../../restaurants/domain/restaurant.dart';
import '../application/review_form_cubit.dart';
import 'widgets/editable_review_criterion_bar.dart';

class ReviewFormPage extends StatefulWidget {
  const ReviewFormPage({
    super.key,
    required this.dependencies,
    required this.restaurantId,
  });

  final AppDependencies dependencies;
  final String restaurantId;

  @override
  State<ReviewFormPage> createState() => _ReviewFormPageState();
}

class _ReviewFormPageState extends State<ReviewFormPage> {
  Restaurant? _restaurant;
  bool _loading = true;
  String? _error;

  @override
  void initState() {
    super.initState();
    _loadRestaurant();
  }

  Future<void> _loadRestaurant() async {
    final result = await widget.dependencies.restaurantsRepository.getById(
      widget.restaurantId,
    );
    if (!mounted) {
      return;
    }
    setState(() {
      _loading = false;
      if (result == null) {
        _error = 'Заведение не найдено';
      } else {
        _restaurant = result;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return Scaffold(
        backgroundColor: AppColors.background,
        body: const Center(
          child: CircularProgressIndicator(color: AppColors.authAccentYellow),
        ),
      );
    }
    if (_error != null) {
      return Scaffold(
        backgroundColor: AppColors.background,
        appBar: AppBar(
          backgroundColor: AppColors.background,
          elevation: 0,
          leading: IconButton(
            onPressed: () => Navigator.of(context).maybePop(),
            icon: const Icon(Icons.arrow_back_ios_new_rounded),
          ),
        ),
        body: Center(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Text(
              _error!,
              textAlign: TextAlign.center,
              style: TextStyle(color: AppColors.textSecondary, fontSize: 16),
            ),
          ),
        ),
      );
    }

    final restaurant = _restaurant!;

    return BlocProvider(
      key: ValueKey<String>(restaurant.id),
      create: (_) => widget.dependencies.createReviewFormCubit(restaurant),
      child: _ReviewFormScaffold(restaurant: restaurant),
    );
  }
}

class _ReviewFormScaffold extends StatelessWidget {
  const _ReviewFormScaffold({required this.restaurant});

  final Restaurant restaurant;

  static (String, Color) _overallCaption(int overallRating) {
    if (overallRating >= 4) {
      return ('Отлично!', const Color(0xFF8B7355));
    }
    if (overallRating >= 3) {
      return ('Хорошо!', AppColors.authAccentYellow);
    }
    if (overallRating >= 2) {
      return ('Неплохо', AppColors.textSecondary);
    }
    return ('Можно лучше', AppColors.textSecondary);
  }

  void _goToReceipt(BuildContext context, ReviewFormState state) {
    Navigator.of(context).pushNamed(
      AppRoutes.receipt,
      arguments: state.toDraft(restaurant.id, restaurant.name),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReviewFormCubit, ReviewFormState>(
      builder: (context, state) {
        final caption = _overallCaption(state.overallRating);
        return Scaffold(
          backgroundColor: AppColors.background,
          body: SafeArea(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Padding(
                  padding: const EdgeInsets.fromLTRB(
                    8,
                    4,
                    ReviewFormUiConstants.horizontalPadding,
                    0,
                  ),
                  child: Row(
                    children: [
                      IconButton(
                        onPressed: () => Navigator.of(context).maybePop(),
                        icon: const Icon(Icons.arrow_back_ios_new_rounded),
                        color: AppColors.textPrimary,
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Оценка сервиса',
                              style: TextStyle(
                                fontSize: 22,
                                fontWeight: FontWeight.bold,
                                color: AppColors.splashTitle,
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              'Оцените ваш визит в ресторан',
                              style: TextStyle(
                                fontSize: 14,
                                color: AppColors.textSecondary,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.fromLTRB(
                      ReviewFormUiConstants.horizontalPadding,
                      16,
                      ReviewFormUiConstants.horizontalPadding,
                      100,
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        _RestaurantInfoCard(restaurant: restaurant),
                        const SizedBox(height: 16),
                        _OverallRatingCard(
                          overallRating: state.overallRating,
                          caption: caption.$1,
                          captionColor: caption.$2,
                          onStarTap: (v) => context
                              .read<ReviewFormCubit>()
                              .setOverallRating(v),
                        ),
                        const SizedBox(height: 16),
                        _CriteriaCard(
                          foodQuality: state.foodQuality,
                          service: state.service,
                          atmosphere: state.atmosphere,
                          priceQuality: state.priceQuality,
                          onFood: context
                              .read<ReviewFormCubit>()
                              .setFoodQuality,
                          onService: context.read<ReviewFormCubit>().setService,
                          onAtmosphere: context
                              .read<ReviewFormCubit>()
                              .setAtmosphere,
                          onPrice: context
                              .read<ReviewFormCubit>()
                              .setPriceQuality,
                        ),
                        const SizedBox(height: 24),
                        _HeroReceiptSection(
                          imageUrl: restaurant.imageUrl,
                          onUpload: () => _goToReceipt(context, state),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _RestaurantInfoCard extends StatelessWidget {
  const _RestaurantInfoCard({required this.restaurant});

  final Restaurant restaurant;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(ReviewFormUiConstants.cardRadius),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              width: 48,
              height: 48,
              decoration: const BoxDecoration(
                color: AppColors.authAccentYellow,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.local_pizza_outlined,
                color: Color(0xFF5C4033),
                size: 26,
              ),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    restaurant.name,
                    style: const TextStyle(
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: AppColors.splashTitle,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    restaurant.address,
                    style: TextStyle(
                      fontSize: 13,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _OverallRatingCard extends StatelessWidget {
  const _OverallRatingCard({
    required this.overallRating,
    required this.caption,
    required this.captionColor,
    required this.onStarTap,
  });

  final int overallRating;
  final String caption;
  final Color captionColor;
  final ValueChanged<int> onStarTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: const Color(0xFFEBEBEB),
      borderRadius: BorderRadius.circular(ReviewFormUiConstants.cardRadius),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 20, horizontal: 16),
        child: Column(
          children: [
            Text(
              'ОБЩАЯ ОЦЕНКА',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.w600,
                letterSpacing: 0.8,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 12),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List<Widget>.generate(5, (int i) {
                final int star = i + 1;
                final bool filled = star <= overallRating;
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  child: InkWell(
                    onTap: () => onStarTap(star),
                    borderRadius: BorderRadius.circular(20),
                    child: Icon(
                      Icons.star_rounded,
                      size: 40,
                      color: filled
                          ? AppColors.brandYellow
                          : AppColors.borderLight,
                    ),
                  ),
                );
              }),
            ),
            const SizedBox(height: 10),
            Text(
              caption,
              style: TextStyle(
                fontSize: 17,
                fontWeight: FontWeight.bold,
                color: captionColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _CriteriaCard extends StatelessWidget {
  const _CriteriaCard({
    required this.foodQuality,
    required this.service,
    required this.atmosphere,
    required this.priceQuality,
    required this.onFood,
    required this.onService,
    required this.onAtmosphere,
    required this.onPrice,
  });

  final int foodQuality;
  final int service;
  final int atmosphere;
  final int priceQuality;
  final ValueChanged<int> onFood;
  final ValueChanged<int> onService;
  final ValueChanged<int> onAtmosphere;
  final ValueChanged<int> onPrice;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      borderRadius: BorderRadius.circular(ReviewFormUiConstants.cardRadius),
      clipBehavior: Clip.antiAlias,
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            EditableReviewCriterionBar(
              label: 'Качество еды',
              value: foodQuality,
              fillColor: VenueCriteriaBarColors.food,
              onChanged: onFood,
            ),
            const SizedBox(height: 18),
            EditableReviewCriterionBar(
              label: 'Обслуживание',
              value: service,
              fillColor: VenueCriteriaBarColors.service,
              onChanged: onService,
            ),
            const SizedBox(height: 18),
            EditableReviewCriterionBar(
              label: 'Атмосфера',
              value: atmosphere,
              fillColor: VenueCriteriaBarColors.atmosphere,
              onChanged: onAtmosphere,
            ),
            const SizedBox(height: 18),
            EditableReviewCriterionBar(
              label: 'Цена/Качество',
              value: priceQuality,
              fillColor: VenueCriteriaBarColors.priceQuality,
              onChanged: onPrice,
            ),
          ],
        ),
      ),
    );
  }
}

class _HeroReceiptSection extends StatelessWidget {
  const _HeroReceiptSection({required this.imageUrl, required this.onUpload});

  final String imageUrl;
  final VoidCallback onUpload;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.vertical(
            top: Radius.circular(ReviewFormUiConstants.heroImageRadius),
          ),
          child: AspectRatio(
            aspectRatio: 1.15,
            child: Image.network(
              imageUrl,
              fit: BoxFit.cover,
              errorBuilder: (context, error, stack) {
                return ColoredBox(
                  color: AppColors.borderLight,
                  child: Icon(
                    Icons.restaurant_rounded,
                    size: 72,
                    color: AppColors.textSecondary,
                  ),
                );
              },
            ),
          ),
        ),
        Transform.translate(
          offset: const Offset(0, -28),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(24),
                gradient: LinearGradient(
                  colors: [const Color(0xFF6B5B3D), AppColors.authAccentYellow],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                ),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(alpha: 0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Material(
                color: Colors.transparent,
                child: InkWell(
                  onTap: onUpload,
                  borderRadius: BorderRadius.circular(24),
                  child: SizedBox(
                    height: ReviewFormUiConstants.primaryActionHeight,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.description_outlined,
                          color: AppColors.textPrimary,
                          size: 24,
                        ),
                        const SizedBox(width: 10),
                        Text(
                          'Загрузить чек',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 4),
      ],
    );
  }
}
