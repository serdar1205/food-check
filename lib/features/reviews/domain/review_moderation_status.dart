/// Moderation state shown in review history (MVP mock).
enum ReviewModerationStatus {
  /// Отзыв принят и верифицирован.
  verified,

  /// Отклонён модерацией.
  rejected,

  /// На проверке.
  underReview,
}
