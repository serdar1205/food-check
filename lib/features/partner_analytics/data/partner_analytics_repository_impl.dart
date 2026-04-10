import '../domain/partner_analytics_repository.dart';
import '../domain/partner_kpi_snapshot.dart';

class PartnerAnalyticsRepositoryImpl implements PartnerAnalyticsRepository {
  @override
  Future<PartnerKpiSnapshot> getDashboard() async {
    return const PartnerKpiSnapshot(
      totalReviews: 1248,
      averageRating: 4.4,
      dynamicChangePercent: 6.8,
      kpiSummary: 'Рост средней оценки за 30 дней',
    );
  }
}
