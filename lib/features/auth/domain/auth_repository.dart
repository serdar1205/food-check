import '../../../core/errors/app_failures.dart';
import '../../../core/result/result.dart';

abstract interface class AuthRepository {
  Future<bool> isAuthorized();

  Future<Result<Null, AuthFailure>> login({
    required String email,
    required String password,
  });

  Future<void> logout();
}
