import 'package:flutter_test/flutter_test.dart';
import 'package:food_check/features/partner_branches/data/partner_branches_repository_impl.dart';

void main() {
  test('branches list and details are available in mock repository', () async {
    final repo = PartnerBranchesRepositoryImpl();
    final list = await repo.listBranches();
    expect(list, isNotEmpty);

    final details = await repo.getDetails(list.first.id);
    expect(details, isNotNull);
    expect(details!.reviews, isNotEmpty);
  });
}
