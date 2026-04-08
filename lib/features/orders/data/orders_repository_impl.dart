import '../domain/order.dart';
import '../domain/orders_repository.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  @override
  Future<List<Order>> getOrders() async {
    return const <Order>[
      Order(
        id: 'o1',
        restaurantName: 'Napoli',
        dateLabel: '8 апреля 2026',
        totalLabel: '3 280 ₽',
        itemsSummary: 'Пицца Маргарита, салат Цезарь',
        status: OrderStatus.completed,
      ),
      Order(
        id: 'o2',
        restaurantName: 'Азбука Вкуса',
        dateLabel: '5 апреля 2026',
        totalLabel: '1 450 ₽',
        itemsSummary: 'Обед на двоих',
        status: OrderStatus.completed,
      ),
      Order(
        id: 'o3',
        restaurantName: 'Терраса',
        dateLabel: '3 апреля 2026',
        totalLabel: '—',
        itemsSummary: 'Бронирование столика',
        status: OrderStatus.pending,
      ),
      Order(
        id: 'o4',
        restaurantName: 'Суши Wok',
        dateLabel: '28 марта 2026',
        totalLabel: '890 ₽',
        itemsSummary: 'Сет Филадельфия',
        status: OrderStatus.cancelled,
      ),
      Order(
        id: 'o5',
        restaurantName: 'Бургер Хаус',
        dateLabel: '20 марта 2026',
        totalLabel: '640 ₽',
        itemsSummary: 'Комбо бургер + картофель',
        status: OrderStatus.completed,
      ),
    ];
  }
}
