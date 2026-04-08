import 'package:flutter_test/flutter_test.dart';
import 'package:food_check/features/reviews/domain/review_draft.dart';

void main() {
  test('review draft is valid when all criteria are in range', () {
    const draft = ReviewDraft(
      restaurantId: '1',
      overallRating: 5,
      foodQuality: 8,
      service: 7,
      atmosphere: 9,
      priceQuality: 6,
    );

    expect(draft.isValid, isTrue);
  });

  test('review draft is invalid when criterion is outside range', () {
    const draft = ReviewDraft(
      restaurantId: '1',
      overallRating: 5,
      foodQuality: 0,
      service: 7,
      atmosphere: 9,
      priceQuality: 6,
    );

    expect(draft.isValid, isFalse);
  });

  test('review draft is invalid when overall is out of range', () {
    const draft = ReviewDraft(
      restaurantId: '1',
      overallRating: 6,
      foodQuality: 8,
      service: 7,
      atmosphere: 9,
      priceQuality: 6,
    );

    expect(draft.isValid, isFalse);
  });
}
