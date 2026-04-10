import '../domain/partner_quality_alerts_repository.dart';
import '../domain/quality_alert.dart';

class PartnerQualityAlertsRepositoryImpl
    implements PartnerQualityAlertsRepository {
  @override
  Future<List<QualityAlert>> listAlerts() async {
    return const [
      QualityAlert(
        id: 'a1',
        branch: 'Центр',
        criterion: 'Сервис',
        event: 'Падение оценки ниже 4.0',
        dateLabel: '10.04.2026',
      ),
      QualityAlert(
        id: 'a2',
        branch: 'Север',
        criterion: 'Чистота',
        event: 'Резкий рост негативных отзывов',
        dateLabel: '09.04.2026',
      ),
    ];
  }
}
