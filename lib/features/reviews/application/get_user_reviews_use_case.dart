import '../domain/user_review_summary.dart';
import '../domain/user_reviews_repository.dart';

class GetUserReviewsUseCase {
  GetUserReviewsUseCase(this._repository);

  final UserReviewsRepository _repository;

  Future<List<UserReviewSummary>> call() => _repository.getMyReviews();
}
