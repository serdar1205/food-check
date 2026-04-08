/// User-facing order / visit record (MVP mock).
class Order {
  const Order({
    required this.id,
    required this.restaurantName,
    required this.dateLabel,
    required this.totalLabel,
    required this.itemsSummary,
    required this.status,
  });

  final String id;
  final String restaurantName;
  final String dateLabel;
  final String totalLabel;
  final String itemsSummary;
  final OrderStatus status;
}

enum OrderStatus { completed, pending, cancelled }
