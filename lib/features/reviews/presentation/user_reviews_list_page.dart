import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/di.dart';
import '../../../core/application/request_status.dart';
import '../../../core/constants/reviews_tab_ui_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../application/user_reviews_list_cubit.dart';
import 'widgets/user_review_card_tile.dart';

class UserReviewsListPage extends StatefulWidget {
  const UserReviewsListPage({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  State<UserReviewsListPage> createState() => _UserReviewsListPageState();
}

class _UserReviewsListPageState extends State<UserReviewsListPage> {
  late final UserReviewsListCubit _cubit;

  @override
  void initState() {
    super.initState();
    _cubit = widget.dependencies.createUserReviewsListCubit()..load();
  }

  @override
  void dispose() {
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<UserReviewsListCubit>.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: AppColors.splashBackground,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  ReviewsTabUiConstants.horizontalPadding,
                  16,
                  ReviewsTabUiConstants.horizontalPadding,
                  8,
                ),
                child: Text(
                  'Отзывы',
                  style: TextStyle(
                    fontSize: 26,
                    fontWeight: FontWeight.bold,
                    color: AppColors.splashTitle,
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: ReviewsTabUiConstants.horizontalPadding,
                ),
                child: Text(
                  'Ваши опубликованные отзывы и на модерации',
                  style: TextStyle(
                    fontSize: 14,
                    color: AppColors.textSecondary,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: BlocBuilder<UserReviewsListCubit, UserReviewsListState>(
                  builder: (context, state) {
                    if (state.status == RequestStatus.loading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.authAccentYellow,
                        ),
                      );
                    }
                    if (state.status == RequestStatus.failure) {
                      return Center(
                        child: Padding(
                          padding: const EdgeInsets.all(24),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text(
                                state.errorMessage ?? 'Не удалось загрузить',
                                textAlign: TextAlign.center,
                                style: TextStyle(
                                  color: AppColors.textSecondary,
                                ),
                              ),
                              const SizedBox(height: 16),
                              FilledButton(
                                onPressed: () =>
                                    context.read<UserReviewsListCubit>().load(),
                                child: const Text('Повторить'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                    if (state.reviews.isEmpty) {
                      return Center(
                        child: Text(
                          'Отзывов пока нет',
                          style: TextStyle(
                            fontSize: 16,
                            color: AppColors.textSecondary,
                          ),
                        ),
                      );
                    }
                    return RefreshIndicator(
                      color: AppColors.authAccentYellow,
                      onRefresh: () =>
                          context.read<UserReviewsListCubit>().load(),
                      child: ListView.builder(
                        padding: const EdgeInsets.fromLTRB(
                          ReviewsTabUiConstants.horizontalPadding,
                          0,
                          ReviewsTabUiConstants.horizontalPadding,
                          24,
                        ),
                        itemCount: state.reviews.length,
                        itemBuilder: (context, index) {
                          final review = state.reviews[index];
                          return UserReviewCardTile(
                            review: review,
                            onTap: () {
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(
                                  content: Text(
                                    'Отзыв ${review.id} — в разработке',
                                  ),
                                ),
                              );
                            },
                          );
                        },
                      ),
                    );
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
