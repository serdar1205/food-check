import 'package:flutter_test/flutter_test.dart';
import 'package:food_check/features/reviews/data/review_history_repository_impl.dart';

void main() {
  test('recordSuccessfulSubmission prepends entries', () async {
    final repo = ReviewHistoryRepositoryImpl();
    await repo.recordSuccessfulSubmission(restaurantId: 'a', bonusPoints: 10);
    await repo.recordSuccessfulSubmission(restaurantId: 'b', bonusPoints: 20);
    final list = await repo.listEntries();
    expect(list.length, 2);
    expect(list[0].restaurantId, 'b');
    expect(list[0].bonusPoints, 20);
    expect(list[1].restaurantId, 'a');
  });
}
