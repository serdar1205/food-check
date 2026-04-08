/// A review shown in the «Отзывы» tab list (MVP mock).
class UserReviewSummary {
  const UserReviewSummary({
    required this.id,
    required this.restaurantName,
    required this.dateLabel,
    required this.overallRating,
    required this.teaser,
    required this.status,
  });

  final String id;
  final String restaurantName;
  final String dateLabel;

  /// 1–5 stars.
  final int overallRating;
  final String teaser;
  final UserReviewPublicationStatus status;
}

enum UserReviewPublicationStatus { published, pendingModeration }
