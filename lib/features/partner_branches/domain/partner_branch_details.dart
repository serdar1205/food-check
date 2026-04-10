class PartnerBranchDetails {
  const PartnerBranchDetails({
    required this.branchId,
    required this.branchName,
    required this.food,
    required this.service,
    required this.cleanliness,
    required this.staff,
    required this.reviews,
  });

  final String branchId;
  final String branchName;
  final int food;
  final int service;
  final int cleanliness;
  final int staff;
  final List<String> reviews;
}
