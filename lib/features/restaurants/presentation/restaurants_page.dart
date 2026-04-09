import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../app/di.dart';
import '../../../app/router.dart';
import '../../../core/application/request_status.dart';
import '../../../core/constants/restaurant_list_ui_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../application/restaurant_list_cubit.dart';
import '../application/restaurant_list_filter.dart';
import '../../notifications/presentation/notifications_page.dart';
import 'widgets/restaurant_card_tile.dart';

class RestaurantsPage extends StatefulWidget {
  const RestaurantsPage({super.key, required this.dependencies});

  final AppDependencies dependencies;

  @override
  State<RestaurantsPage> createState() => _RestaurantsPageState();
}

class _RestaurantsPageState extends State<RestaurantsPage> {
  late final RestaurantListCubit _cubit;
  final _searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _cubit = widget.dependencies.createRestaurantListCubit()..load();
  }

  @override
  void dispose() {
    _searchController.dispose();
    _cubit.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<RestaurantListCubit>.value(
      value: _cubit,
      child: Scaffold(
        backgroundColor: AppColors.splashBackground,
        body: SafeArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(
                  RestaurantListUiConstants.horizontalPadding,
                  8,
                  RestaurantListUiConstants.horizontalPadding,
                  0,
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: Text(
                        'Рестораны',
                        style: TextStyle(
                          fontSize: RestaurantListUiConstants.headerTitleSize,
                          fontWeight: FontWeight.bold,
                          color: AppColors.splashTitle,
                        ),
                      ),
                    ),
                    Material(
                      color: AppColors.background,
                      shape: const CircleBorder(),
                      clipBehavior: Clip.antiAlias,
                      child: InkWell(
                        onTap: () {
                          Navigator.of(context).push<void>(
                            MaterialPageRoute<void>(
                              builder: (_) => NotificationsPage(
                                dependencies: widget.dependencies,
                              ),
                            ),
                          );
                        },
                        child: const Padding(
                          padding: EdgeInsets.all(10),
                          child: Icon(
                            Icons.notifications_outlined,
                            color: AppColors.textPrimary,
                            size: 22,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 16),
              Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: RestaurantListUiConstants.horizontalPadding,
                ),
                child: TextField(
                  controller: _searchController,
                  onChanged: (value) =>
                      context.read<RestaurantListCubit>().setSearchQuery(value),
                  decoration: InputDecoration(
                    hintText: 'Поиск ресторанов...',
                    hintStyle: TextStyle(
                      color: AppColors.textSecondary.withValues(alpha: 0.85),
                      fontSize: 15,
                    ),
                    prefixIcon: Icon(
                      Icons.search_rounded,
                      color: AppColors.textSecondary,
                      size: 24,
                    ),
                    filled: true,
                    fillColor: AppColors.background,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        RestaurantListUiConstants.searchRadius,
                      ),
                      borderSide: BorderSide.none,
                    ),
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 8,
                      vertical: 14,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              BlocBuilder<RestaurantListCubit, RestaurantListState>(
                buildWhen: (previous, current) =>
                    previous.selectedFilter != current.selectedFilter,
                builder: (context, state) {
                  return SizedBox(
                    height: 40,
                    child: ListView(
                      scrollDirection: Axis.horizontal,
                      padding: const EdgeInsets.symmetric(
                        horizontal: RestaurantListUiConstants.horizontalPadding,
                      ),
                      children: [
                        _FilterChipButton(
                          label: 'Все',
                          selected:
                              state.selectedFilter == RestaurantListFilter.all,
                          onTap: () => context
                              .read<RestaurantListCubit>()
                              .setFilter(RestaurantListFilter.all),
                        ),
                        const SizedBox(width: 8),
                        _FilterChipButton(
                          label: 'Рядом',
                          selected:
                              state.selectedFilter ==
                              RestaurantListFilter.nearby,
                          onTap: () => context
                              .read<RestaurantListCubit>()
                              .setFilter(RestaurantListFilter.nearby),
                        ),
                        const SizedBox(width: 8),
                        _FilterChipButton(
                          label: 'Популярные',
                          selected:
                              state.selectedFilter ==
                              RestaurantListFilter.popular,
                          onTap: () => context
                              .read<RestaurantListCubit>()
                              .setFilter(RestaurantListFilter.popular),
                        ),
                        const SizedBox(width: 8),
                        _FilterChipButton(
                          label: 'Новые',
                          selected:
                              state.selectedFilter ==
                              RestaurantListFilter.newest,
                          onTap: () => context
                              .read<RestaurantListCubit>()
                              .setFilter(RestaurantListFilter.newest),
                        ),
                      ],
                    ),
                  );
                },
              ),
              const SizedBox(height: 12),
              Expanded(
                child: BlocBuilder<RestaurantListCubit, RestaurantListState>(
                  buildWhen: (previous, current) =>
                      previous.status != current.status ||
                      previous.allItems != current.allItems ||
                      previous.searchQuery != current.searchQuery ||
                      previous.selectedFilter != current.selectedFilter,
                  builder: (context, state) {
                    if (state.status == RequestStatus.loading) {
                      return const Center(
                        child: CircularProgressIndicator(
                          color: AppColors.authAccentYellow,
                        ),
                      );
                    }
                    final items = state.visibleItems;
                    if (items.isEmpty) {
                      return Center(
                        child: Text(
                          'Ничего не найдено',
                          style: TextStyle(
                            color: AppColors.textSecondary,
                            fontSize: 16,
                          ),
                        ),
                      );
                    }
                    return ListView.builder(
                      padding: const EdgeInsets.fromLTRB(
                        RestaurantListUiConstants.horizontalPadding,
                        4,
                        RestaurantListUiConstants.horizontalPadding,
                        16,
                      ),
                      itemCount: items.length,
                      itemBuilder: (context, index) {
                        final restaurant = items[index];
                        return RestaurantCardTile(
                          restaurant: restaurant,
                          onTap: () => Navigator.of(context).pushNamed(
                            AppRoutes.details,
                            arguments: restaurant.id,
                          ),
                        );
                      },
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

class _FilterChipButton extends StatelessWidget {
  const _FilterChipButton({
    required this.label,
    required this.selected,
    required this.onTap,
  });

  final String label;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: selected ? AppColors.authAccentYellow : AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(
          RestaurantListUiConstants.chipRadius,
        ),
        side: BorderSide(
          color: selected ? AppColors.authAccentYellow : AppColors.borderLight,
        ),
      ),
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Text(
            label,
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: selected ? AppColors.surface : AppColors.splashTitle,
            ),
          ),
        ),
      ),
    );
  }
}
