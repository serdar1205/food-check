import 'quality_alert.dart';

abstract interface class PartnerQualityAlertsRepository {
  Future<List<QualityAlert>> listAlerts();
}
