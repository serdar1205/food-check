import 'package:flutter_test/flutter_test.dart';
import 'package:food_check/features/auth/data/auth_repository_impl.dart';
import 'package:food_check/features/splash/application/check_authorization_use_case.dart';
import 'package:food_check/features/splash/application/splash_cubit.dart';
import 'package:food_check/features/splash/application/splash_destination.dart';

void main() {
  test('routes to auth when unauthorized', () async {
    final cubit = SplashCubit(
      CheckAuthorizationUseCase(AuthRepositoryImpl()),
      minDisplayDuration: Duration.zero,
    );

    await cubit.initialize();

    expect(cubit.state.destination, SplashDestination.unauthorized);
    await cubit.close();
  });
}
