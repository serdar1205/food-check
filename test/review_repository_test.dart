import 'package:flutter_test/flutter_test.dart';
import 'package:food_check/core/errors/app_failures.dart';
import 'package:food_check/core/result/result.dart';
import 'package:food_check/features/review_result/domain/review_result.dart';
import 'package:food_check/features/reviews/data/review_repository_impl.dart';
import 'package:food_check/features/reviews/domain/review_draft.dart';

void main() {
  test('returns duplicate failure for reused receipt', () async {
    final repository = ReviewRepositoryImpl();
    const draft = ReviewDraft(
      restaurantId: '1',
      overallRating: 5,
      foodQuality: 8,
      service: 8,
      atmosphere: 8,
      priceQuality: 8,
    );

    final result = await repository.submitReview(draft, 'used-receipt.jpg');

    expect(result, isA<Failure<ReviewResultEntity, ReviewFailure>>());
    final failure = result as Failure<ReviewResultEntity, ReviewFailure>;
    expect(failure.error, ReviewFailure.receiptAlreadyUsed);
  });
}
