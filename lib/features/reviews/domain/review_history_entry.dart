import 'review_moderation_status.dart';

class ReviewHistoryEntry {
  const ReviewHistoryEntry({
    required this.id,
    required this.restaurantId,
    required this.restaurantName,
    required this.submittedAt,
    required this.bonusPoints,
    required this.status,
  });

  final String id;
  final String restaurantId;
  final String restaurantName;
  final DateTime submittedAt;
  final int bonusPoints;
  final ReviewModerationStatus status;
}
