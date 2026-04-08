import '../../../core/errors/app_failures.dart';
import '../../../core/result/result.dart';
import '../domain/auth_repository.dart';

class LoginUseCase {
  LoginUseCase(this._repository);

  final AuthRepository _repository;

  Future<Result<Null, AuthFailure>> call({
    required String email,
    required String password,
  }) {
    return _repository.login(email: email, password: password);
  }
}
