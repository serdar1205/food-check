import '../../../core/errors/app_failures.dart';
import '../../../core/result/result.dart';
import '../domain/profile_repository.dart';
import '../domain/user_profile.dart';

class GetProfileUseCase {
  GetProfileUseCase(this._repository);

  final ProfileRepository _repository;

  Future<Result<UserProfile, ProfileFailure>> call() {
    return _repository.getProfile();
  }
}
