import '../../../core/errors/app_failures.dart';
import '../../../core/result/result.dart';
import '../domain/auth_repository.dart';

/// In-memory auth for local development. Replace with Firebase Auth in data layer.
class AuthRepositoryImpl implements AuthRepository {
  bool _authorized = false;

  @override
  Future<bool> isAuthorized() async => _authorized;

  @override
  Future<Result<Null, AuthFailure>> login({
    required String email,
    required String password,
  }) async {
    if (email.isEmpty || password.isEmpty) {
      return const Failure(AuthFailure.invalidCredentials);
    }
    _authorized = true;
    return const Success<Null, AuthFailure>(null);
  }

  @override
  Future<void> logout() async {
    _authorized = false;
  }
}
