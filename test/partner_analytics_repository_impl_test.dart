import 'package:flutter_test/flutter_test.dart';
import 'package:food_check/features/partner_analytics/data/partner_analytics_repository_impl.dart';

void main() {
  test('dashboard mock data is returned', () async {
    final repo = PartnerAnalyticsRepositoryImpl();
    final data = await repo.getDashboard();

    expect(data.totalReviews, greaterThan(0));
    expect(data.averageRating, greaterThan(0));
    expect(data.kpiSummary, isNotEmpty);
  });
}
