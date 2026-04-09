import '../domain/review_moderation_status.dart';

extension ReviewModerationStatusRu on ReviewModerationStatus {
  String get labelRu {
    return switch (this) {
      ReviewModerationStatus.verified => 'Верифицирован',
      ReviewModerationStatus.rejected => 'Отклонён',
      ReviewModerationStatus.underReview => 'На проверке',
    };
  }
}
