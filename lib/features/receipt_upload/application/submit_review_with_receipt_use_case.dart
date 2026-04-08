import '../../../core/errors/app_failures.dart';
import '../../../core/result/result.dart';
import '../../profile/domain/profile_repository.dart';
import '../../review_result/domain/review_result.dart';
import '../../reviews/domain/review_draft.dart';
import '../../reviews/domain/review_history_repository.dart';
import '../../reviews/domain/review_repository.dart';

class SubmitReviewWithReceiptUseCase {
  SubmitReviewWithReceiptUseCase(
    this._reviewRepository,
    this._profileRepository,
    this._historyRepository,
  );

  final ReviewRepository _reviewRepository;
  final ProfileRepository _profileRepository;
  final ReviewHistoryRepository _historyRepository;

  Future<Result<ReviewResultEntity, ReviewFailure>> call(
    ReviewDraft draft,
    String receiptPath,
  ) async {
    final result = await _reviewRepository.submitReview(draft, receiptPath);
    return result.when(
      success: (ReviewResultEntity value) async {
        if (value.isSuccess) {
          if (value.bonusPoints > 0) {
            await _profileRepository.applyBonusAward(value.bonusPoints);
          }
          await _historyRepository.recordSuccessfulSubmission(
            restaurantId: draft.restaurantId,
            bonusPoints: value.bonusPoints,
          );
        }
        return Success(value);
      },
      failure: (ReviewFailure error) async => Failure(error),
    );
  }
}
