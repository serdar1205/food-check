import '../../../core/errors/app_failures.dart';
import '../../../core/result/result.dart';
import '../../review_result/domain/review_result.dart';
import '../domain/review_draft.dart';
import '../domain/review_repository.dart';

/// Simulates receipt deduplication and bonus grant. Swap for Firestore + Storage.
class ReviewRepositoryImpl implements ReviewRepository {
  final Set<String> _usedReceipts = <String>{'used-receipt.jpg'};

  @override
  Future<Result<ReviewResultEntity, ReviewFailure>> submitReview(
    ReviewDraft draft,
    String receiptPath,
  ) async {
    if (!draft.isValid) {
      return const Failure(ReviewFailure.invalidDraft);
    }
    if (receiptPath.isEmpty) {
      return const Failure(ReviewFailure.uploadFailed);
    }
    if (_usedReceipts.contains(receiptPath)) {
      return const Failure(ReviewFailure.receiptAlreadyUsed);
    }

    _usedReceipts.add(receiptPath);
    return const Success(ReviewResultEntity.success(50));
  }
}
