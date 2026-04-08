import '../../../core/errors/app_failures.dart';
import '../../../core/result/result.dart';
import 'user_profile.dart';

abstract interface class ProfileRepository {
  Future<Result<UserProfile, ProfileFailure>> getProfile();

  /// Adds bonus points after a successful review submission (in-memory MVP).
  Future<Result<void, ProfileFailure>> applyBonusAward(int points);
}
