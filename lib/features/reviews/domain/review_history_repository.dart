import 'review_history_entry.dart';
import 'review_moderation_status.dart';

abstract interface class ReviewHistoryRepository {
  Future<void> recordSuccessfulSubmission({
    required String restaurantId,
    required String restaurantName,
    required int bonusPoints,
    required ReviewModerationStatus initialStatus,
  });

  Future<List<ReviewHistoryEntry>> listEntries();
}
