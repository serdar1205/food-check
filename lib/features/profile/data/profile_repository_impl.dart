import '../../../core/errors/app_failures.dart';
import '../../../core/result/result.dart';
import '../domain/profile_repository.dart';
import '../domain/user_profile.dart';

class ProfileRepositoryImpl implements ProfileRepository {
  UserProfile _profile = const UserProfile(
    name: 'Иван Иванов',
    email: 'ivanov@example.com',
    avatarUrl: 'https://i.pravatar.cc/256?img=12',
    bonusBalance: 250,
  );

  @override
  Future<Result<UserProfile, ProfileFailure>> getProfile() async {
    return Success(_profile);
  }

  @override
  Future<Result<void, ProfileFailure>> applyBonusAward(int points) async {
    if (points < 0) {
      return const Failure(ProfileFailure.unknown);
    }
    if (points == 0) {
      return const Success(null);
    }
    _profile = UserProfile(
      name: _profile.name,
      email: _profile.email,
      avatarUrl: _profile.avatarUrl,
      bonusBalance: _profile.bonusBalance + points,
    );
    return const Success(null);
  }
}
