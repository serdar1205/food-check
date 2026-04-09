import 'package:flutter_test/flutter_test.dart';
import 'package:food_check/features/reviews/data/review_history_repository_impl.dart';
import 'package:food_check/features/reviews/domain/review_moderation_status.dart';

void main() {
  test('recordSuccessfulSubmission prepends entries before seed data', () async {
    final repo = ReviewHistoryRepositoryImpl();
    await repo.recordSuccessfulSubmission(
      restaurantId: 'a',
      restaurantName: 'A',
      bonusPoints: 10,
      initialStatus: ReviewModerationStatus.underReview,
    );
    await repo.recordSuccessfulSubmission(
      restaurantId: 'b',
      restaurantName: 'B',
      bonusPoints: 20,
      initialStatus: ReviewModerationStatus.underReview,
    );
    final list = await repo.listEntries();
    expect(list.length, 5);
    expect(list[0].restaurantId, 'b');
    expect(list[0].bonusPoints, 20);
    expect(list[1].restaurantId, 'a');
    expect(list[1].bonusPoints, 10);
  });
}
