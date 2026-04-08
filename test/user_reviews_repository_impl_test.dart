import 'package:flutter_test/flutter_test.dart';
import 'package:food_check/features/reviews/data/user_reviews_repository_impl.dart';

void main() {
  test('getMyReviews returns mock list', () async {
    final repo = UserReviewsRepositoryImpl();
    final list = await repo.getMyReviews();
    expect(list, isNotEmpty);
    expect(list.first.restaurantName, isNotEmpty);
  });
}
