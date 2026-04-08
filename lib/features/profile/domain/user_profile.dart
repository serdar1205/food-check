class UserProfile {
  const UserProfile({
    required this.name,
    required this.email,
    required this.avatarUrl,
    required this.bonusBalance,
  });

  final String name;
  final String email;
  final String avatarUrl;
  final int bonusBalance;
}
