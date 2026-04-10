import '../domain/partner_branch.dart';
import '../domain/partner_branch_details.dart';
import '../domain/partner_branches_repository.dart';

class PartnerBranchesRepositoryImpl implements PartnerBranchesRepository {
  static const _branches = <PartnerBranch>[
    PartnerBranch(
      id: 'b1',
      name: 'Центр',
      rating: 4.5,
      shortStat: '312 отзывов / месяц',
    ),
    PartnerBranch(
      id: 'b2',
      name: 'Север',
      rating: 4.2,
      shortStat: '211 отзывов / месяц',
    ),
    PartnerBranch(
      id: 'b3',
      name: 'Юг',
      rating: 4.0,
      shortStat: '178 отзывов / месяц',
    ),
  ];

  @override
  Future<List<PartnerBranch>> listBranches() async => _branches;

  @override
  Future<PartnerBranchDetails?> getDetails(String branchId) async {
    PartnerBranch? b;
    for (final branch in _branches) {
      if (branch.id == branchId) {
        b = branch;
        break;
      }
    }
    if (b == null) {
      return null;
    }
    return PartnerBranchDetails(
      branchId: b.id,
      branchName: b.name,
      food: 8,
      service: 7,
      cleanliness: 9,
      staff: 8,
      reviews: const [
        'Отличный сервис, но ожидание в пиковое время.',
        'Хорошее качество блюд и чистый зал.',
        'Нужно ускорить обслуживание на кассе.',
      ],
    );
  }
}
