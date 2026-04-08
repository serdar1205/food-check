import '../domain/order.dart';
import '../domain/orders_repository.dart';

class GetOrdersUseCase {
  GetOrdersUseCase(this._repository);

  final OrdersRepository _repository;

  Future<List<Order>> call() => _repository.getOrders();
}
