import '../domain/review_history_entry.dart';
import '../domain/review_history_repository.dart';
import '../domain/review_moderation_status.dart';

class ReviewHistoryRepositoryImpl implements ReviewHistoryRepository {
  ReviewHistoryRepositoryImpl() {
    _entries.addAll(_seedEntries);
  }

  final List<ReviewHistoryEntry> _entries = <ReviewHistoryEntry>[];

  static final List<ReviewHistoryEntry> _seedEntries = <ReviewHistoryEntry>[
    ReviewHistoryEntry(
      id: 'h-seed-1',
      restaurantId: '1',
      restaurantName: 'Пиццерия Наполи',
      submittedAt: DateTime(2025, 11, 2, 14, 30),
      bonusPoints: 50,
      status: ReviewModerationStatus.verified,
    ),
    ReviewHistoryEntry(
      id: 'h-seed-2',
      restaurantId: '2',
      restaurantName: 'Суши-бар «Токио»',
      submittedAt: DateTime(2025, 12, 18, 19, 0),
      bonusPoints: 0,
      status: ReviewModerationStatus.rejected,
    ),
    ReviewHistoryEntry(
      id: 'h-seed-3',
      restaurantId: '3',
      restaurantName: 'Бургерная «Гриль Хаус»',
      submittedAt: DateTime(2026, 1, 5, 12, 15),
      bonusPoints: 30,
      status: ReviewModerationStatus.underReview,
    ),
  ];

  @override
  Future<List<ReviewHistoryEntry>> listEntries() async {
    return List<ReviewHistoryEntry>.unmodifiable(_entries);
  }

  @override
  Future<void> recordSuccessfulSubmission({
    required String restaurantId,
    required String restaurantName,
    required int bonusPoints,
    required ReviewModerationStatus initialStatus,
  }) async {
    final name = restaurantName.trim().isEmpty ? restaurantId : restaurantName;
    _entries.insert(
      0,
      ReviewHistoryEntry(
        id: 'h-${DateTime.now().microsecondsSinceEpoch}',
        restaurantId: restaurantId,
        restaurantName: name,
        submittedAt: DateTime.now(),
        bonusPoints: bonusPoints,
        status: initialStatus,
      ),
    );
  }
}
