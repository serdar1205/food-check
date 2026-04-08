import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/application/request_status.dart';
import '../domain/order.dart';
import 'get_orders_use_case.dart';

class OrdersListState {
  const OrdersListState({
    required this.status,
    this.orders = const <Order>[],
    this.errorMessage,
  });

  const OrdersListState.initial()
    : status = RequestStatus.idle,
      orders = const <Order>[],
      errorMessage = null;

  final RequestStatus status;
  final List<Order> orders;
  final String? errorMessage;

  OrdersListState copyWith({
    RequestStatus? status,
    List<Order>? orders,
    String? errorMessage,
    bool clearError = false,
  }) {
    return OrdersListState(
      status: status ?? this.status,
      orders: orders ?? this.orders,
      errorMessage: clearError ? null : (errorMessage ?? this.errorMessage),
    );
  }
}

class OrdersListCubit extends Cubit<OrdersListState> {
  OrdersListCubit(this._getOrders) : super(const OrdersListState.initial());

  final GetOrdersUseCase _getOrders;

  Future<void> load() async {
    emit(state.copyWith(status: RequestStatus.loading, clearError: true));
    try {
      final list = await _getOrders();
      emit(state.copyWith(status: RequestStatus.success, orders: list));
    } on Object catch (e) {
      emit(
        state.copyWith(
          status: RequestStatus.failure,
          errorMessage: e.toString(),
        ),
      );
    }
  }
}
