import 'package:flutter_test/flutter_test.dart';
import 'package:food_check/core/errors/app_failures.dart';
import 'package:food_check/core/result/result.dart';
import 'package:food_check/features/profile/domain/profile_repository.dart';
import 'package:food_check/features/profile/domain/user_profile.dart';
import 'package:food_check/features/receipt_upload/application/submit_review_with_receipt_use_case.dart';
import 'package:food_check/features/review_result/domain/review_result.dart';
import 'package:food_check/features/reviews/domain/review_draft.dart';
import 'package:food_check/features/reviews/domain/review_history_entry.dart';
import 'package:food_check/features/reviews/domain/review_history_repository.dart';
import 'package:food_check/features/reviews/domain/review_repository.dart';

void main() {
  final draft = ReviewDraft(
    restaurantId: 'r1',
    overallRating: 5,
    foodQuality: 8,
    service: 8,
    atmosphere: 8,
    priceQuality: 8,
  );

  test('applies bonus and records history on successful submit', () async {
    final review = _FakeReviewRepository(
      result: const Success(ReviewResultEntity.success(50)),
    );
    final profile = _FakeProfileRepository();
    final history = _FakeReviewHistoryRepository();
    final useCase = SubmitReviewWithReceiptUseCase(review, profile, history);

    final out = await useCase.call(draft, 'new-receipt.jpg');

    expect(out, isA<Success<ReviewResultEntity, ReviewFailure>>());
    expect(profile.awardCalls, [50]);
    expect(history.recordCalls.length, 1);
    expect(history.recordCalls.first.restaurantId, 'r1');
    expect(history.recordCalls.first.bonusPoints, 50);
  });

  test('does not apply bonus or history on failure', () async {
    final review = _FakeReviewRepository(
      result: const Failure(ReviewFailure.receiptAlreadyUsed),
    );
    final profile = _FakeProfileRepository();
    final history = _FakeReviewHistoryRepository();
    final useCase = SubmitReviewWithReceiptUseCase(review, profile, history);

    final out = await useCase.call(draft, 'used-receipt.jpg');

    expect(out, isA<Failure<ReviewResultEntity, ReviewFailure>>());
    expect(profile.awardCalls, isEmpty);
    expect(history.recordCalls, isEmpty);
  });
}

class _FakeReviewRepository implements ReviewRepository {
  _FakeReviewRepository({required this.result});

  final Result<ReviewResultEntity, ReviewFailure> result;

  @override
  Future<Result<ReviewResultEntity, ReviewFailure>> submitReview(
    ReviewDraft draft,
    String receiptPath,
  ) async {
    return result;
  }
}

class _FakeProfileRepository implements ProfileRepository {
  final List<int> awardCalls = [];

  @override
  Future<Result<void, ProfileFailure>> applyBonusAward(int points) async {
    awardCalls.add(points);
    return const Success(null);
  }

  @override
  Future<Result<UserProfile, ProfileFailure>> getProfile() async {
    throw UnimplementedError();
  }
}

class _FakeReviewHistoryRepository implements ReviewHistoryRepository {
  final List<({String restaurantId, int bonusPoints})> recordCalls = [];

  @override
  Future<List<ReviewHistoryEntry>> listEntries() async => [];

  @override
  Future<void> recordSuccessfulSubmission({
    required String restaurantId,
    required int bonusPoints,
  }) async {
    recordCalls.add((restaurantId: restaurantId, bonusPoints: bonusPoints));
  }
}
