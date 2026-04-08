class ReviewHistoryEntry {
  const ReviewHistoryEntry({
    required this.id,
    required this.restaurantId,
    required this.submittedAt,
    required this.bonusPoints,
  });

  final String id;
  final String restaurantId;
  final DateTime submittedAt;
  final int bonusPoints;
}
