import 'package:flutter_test/flutter_test.dart';
import 'package:food_check/core/application/request_status.dart';
import 'package:food_check/features/auth/application/auth_cubit.dart';
import 'package:food_check/features/auth/application/login_use_case.dart';
import 'package:food_check/features/auth/data/auth_repository_impl.dart';

void main() {
  test('role defaults to client and can be switched to partner', () {
    final cubit = AuthCubit(LoginUseCase(AuthRepositoryImpl()));
    expect(cubit.state.role, AppUserRole.client);

    cubit.setRole(AppUserRole.partner);

    expect(cubit.state.role, AppUserRole.partner);
    cubit.close();
  });

  test('login success keeps selected role', () async {
    final cubit = AuthCubit(LoginUseCase(AuthRepositoryImpl()));
    cubit.setRole(AppUserRole.partner);

    await cubit.login('partner@demo.com', '123456');

    expect(cubit.state.status, RequestStatus.success);
    expect(cubit.state.role, AppUserRole.partner);
    await cubit.close();
  });
}
