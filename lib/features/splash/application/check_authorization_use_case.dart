import '../../auth/domain/auth_repository.dart';

class CheckAuthorizationUseCase {
  CheckAuthorizationUseCase(this._repository);

  final AuthRepository _repository;

  Future<bool> call() => _repository.isAuthorized();
}
