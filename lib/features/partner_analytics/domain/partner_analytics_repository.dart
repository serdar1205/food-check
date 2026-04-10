import 'partner_kpi_snapshot.dart';

abstract interface class PartnerAnalyticsRepository {
  Future<PartnerKpiSnapshot> getDashboard();
}
