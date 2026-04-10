class PartnerKpiSnapshot {
  const PartnerKpiSnapshot({
    required this.totalReviews,
    required this.averageRating,
    required this.dynamicChangePercent,
    required this.kpiSummary,
  });

  final int totalReviews;
  final double averageRating;
  final double dynamicChangePercent;
  final String kpiSummary;
}
