import '../../../core/errors/app_failures.dart';
import '../../../core/result/result.dart';
import '../../review_result/domain/review_result.dart';
import 'review_draft.dart';

abstract interface class ReviewRepository {
  Future<Result<ReviewResultEntity, ReviewFailure>> submitReview(
    ReviewDraft draft,
    String receiptPath,
  );
}
