class ReviewResultEntity {
  const ReviewResultEntity.success(this.bonusPoints)
    : isSuccess = true,
      reason = null;

  const ReviewResultEntity.failure(this.reason)
    : isSuccess = false,
      bonusPoints = 0;

  final bool isSuccess;
  final int bonusPoints;
  final String? reason;
}
