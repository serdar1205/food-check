/// User input before receipt upload.
class ReviewDraft {
  const ReviewDraft({
    required this.restaurantId,
    required this.restaurantName,
    required this.overallRating,
    required this.foodQuality,
    required this.service,
    required this.atmosphere,
    required this.priceQuality,
    this.comment,
  });

  static const int minCriterion = 1;
  static const int maxCriterion = 10;
  static const int minOverall = 1;
  static const int maxOverall = 5;

  final String restaurantId;
  final String restaurantName;

  /// 1–5 stars.
  final int overallRating;

  /// 1–10 each, aligned with venue criteria.
  final int foodQuality;
  final int service;
  final int atmosphere;
  final int priceQuality;

  final String? comment;

  bool get isValid {
    if (overallRating < minOverall || overallRating > maxOverall) {
      return false;
    }
    final scores = <int>[foodQuality, service, atmosphere, priceQuality];
    return scores.every((v) => v >= minCriterion && v <= maxCriterion);
  }
}
