import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/application/request_status.dart';
import '../domain/restaurant.dart';
import 'get_restaurants_use_case.dart';
import 'restaurant_list_filter.dart';

class RestaurantListState {
  const RestaurantListState({
    required this.status,
    required this.allItems,
    required this.searchQuery,
    required this.selectedFilter,
  });

  const RestaurantListState.initial()
    : status = RequestStatus.idle,
      allItems = const <Restaurant>[],
      searchQuery = '',
      selectedFilter = RestaurantListFilter.all;

  final RequestStatus status;
  final List<Restaurant> allItems;
  final String searchQuery;
  final RestaurantListFilter selectedFilter;

  List<Restaurant> get visibleItems {
    var list = List<Restaurant>.from(allItems);
    switch (selectedFilter) {
      case RestaurantListFilter.all:
      case RestaurantListFilter.nearby:
        break;
      case RestaurantListFilter.popular:
        list = list.where((e) => e.rating >= 4.5).toList();
      case RestaurantListFilter.newest:
        list = list.where((e) => e.isNew).toList();
    }
    final q = searchQuery.trim().toLowerCase();
    if (q.isNotEmpty) {
      list = list
          .where(
            (e) =>
                e.name.toLowerCase().contains(q) ||
                e.cuisine.toLowerCase().contains(q) ||
                e.address.toLowerCase().contains(q),
          )
          .toList();
    }
    return list;
  }

  RestaurantListState copyWith({
    RequestStatus? status,
    List<Restaurant>? allItems,
    String? searchQuery,
    RestaurantListFilter? selectedFilter,
  }) {
    return RestaurantListState(
      status: status ?? this.status,
      allItems: allItems ?? this.allItems,
      searchQuery: searchQuery ?? this.searchQuery,
      selectedFilter: selectedFilter ?? this.selectedFilter,
    );
  }
}

class RestaurantListCubit extends Cubit<RestaurantListState> {
  RestaurantListCubit(this._getRestaurants)
    : super(const RestaurantListState.initial());

  final GetRestaurantsUseCase _getRestaurants;

  Future<void> load() async {
    emit(state.copyWith(status: RequestStatus.loading));
    final items = await _getRestaurants();
    emit(state.copyWith(status: RequestStatus.success, allItems: items));
  }

  void setSearchQuery(String query) {
    emit(state.copyWith(searchQuery: query));
  }

  void setFilter(RestaurantListFilter filter) {
    emit(state.copyWith(selectedFilter: filter));
  }
}
