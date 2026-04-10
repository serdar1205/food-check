import 'partner_branch.dart';
import 'partner_branch_details.dart';

abstract interface class PartnerBranchesRepository {
  Future<List<PartnerBranch>> listBranches();
  Future<PartnerBranchDetails?> getDetails(String branchId);
}
