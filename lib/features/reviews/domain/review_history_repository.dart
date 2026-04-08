import 'review_history_entry.dart';

abstract interface class ReviewHistoryRepository {
  Future<void> recordSuccessfulSubmission({
    required String restaurantId,
    required int bonusPoints,
  });

  Future<List<ReviewHistoryEntry>> listEntries();
}
