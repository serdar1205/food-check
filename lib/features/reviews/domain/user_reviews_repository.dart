import 'user_review_summary.dart';

abstract interface class UserReviewsRepository {
  Future<List<UserReviewSummary>> getMyReviews();
}
