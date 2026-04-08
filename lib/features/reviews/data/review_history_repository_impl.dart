import '../domain/review_history_entry.dart';
import '../domain/review_history_repository.dart';

class ReviewHistoryRepositoryImpl implements ReviewHistoryRepository {
  final List<ReviewHistoryEntry> _entries = <ReviewHistoryEntry>[];

  @override
  Future<List<ReviewHistoryEntry>> listEntries() async {
    return List<ReviewHistoryEntry>.unmodifiable(_entries);
  }

  @override
  Future<void> recordSuccessfulSubmission({
    required String restaurantId,
    required int bonusPoints,
  }) async {
    _entries.insert(
      0,
      ReviewHistoryEntry(
        id: 'h-${DateTime.now().microsecondsSinceEpoch}',
        restaurantId: restaurantId,
        submittedAt: DateTime.now(),
        bonusPoints: bonusPoints,
      ),
    );
  }
}
