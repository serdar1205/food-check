import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/application/request_status.dart';
import '../domain/restaurant.dart';
import 'get_restaurant_by_id_use_case.dart';

class VenueDetailsState {
  const VenueDetailsState({
    required this.status,
    this.restaurant,
    this.message,
  });

  const VenueDetailsState.initial()
    : status = RequestStatus.idle,
      restaurant = null,
      message = null;

  final RequestStatus status;
  final Restaurant? restaurant;
  final String? message;

  VenueDetailsState copyWith({
    RequestStatus? status,
    Restaurant? restaurant,
    String? message,
  }) {
    return VenueDetailsState(
      status: status ?? this.status,
      restaurant: restaurant ?? this.restaurant,
      message: message ?? this.message,
    );
  }
}

class VenueDetailsCubit extends Cubit<VenueDetailsState> {
  VenueDetailsCubit(this._getById, this._restaurantId)
    : super(const VenueDetailsState.initial());

  final GetRestaurantByIdUseCase _getById;
  final String _restaurantId;

  Future<void> load() async {
    emit(state.copyWith(status: RequestStatus.loading, message: null));
    final restaurant = await _getById(_restaurantId);
    if (restaurant == null) {
      emit(
        state.copyWith(
          status: RequestStatus.failure,
          message: 'Заведение не найдено.',
        ),
      );
      return;
    }
    emit(state.copyWith(status: RequestStatus.success, restaurant: restaurant));
  }
}
