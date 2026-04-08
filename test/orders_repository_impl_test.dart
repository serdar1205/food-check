import 'package:flutter_test/flutter_test.dart';
import 'package:food_check/features/orders/data/orders_repository_impl.dart';

void main() {
  test('getOrders returns mock list', () async {
    final repo = OrdersRepositoryImpl();
    final list = await repo.getOrders();
    expect(list, isNotEmpty);
    expect(list.first.restaurantName, isNotEmpty);
  });
}
