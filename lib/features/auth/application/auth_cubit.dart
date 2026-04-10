import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/application/request_status.dart';
import '../../../core/errors/app_failures.dart';
import 'login_use_case.dart';

enum AppUserRole { client, partner }

class AuthState {
  const AuthState({required this.status, required this.role, this.message});

  const AuthState.initial()
    : status = RequestStatus.idle,
      role = AppUserRole.client,
      message = null;

  final RequestStatus status;
  final AppUserRole role;
  final String? message;

  AuthState copyWith({
    RequestStatus? status,
    AppUserRole? role,
    String? message,
    bool clearMessage = false,
  }) {
    return AuthState(
      status: status ?? this.status,
      role: role ?? this.role,
      message: clearMessage ? null : (message ?? this.message),
    );
  }
}

class AuthCubit extends Cubit<AuthState> {
  AuthCubit(this._loginUseCase) : super(const AuthState.initial());

  final LoginUseCase _loginUseCase;

  void setRole(AppUserRole role) {
    emit(state.copyWith(role: role));
  }

  Future<void> login(String email, String password) async {
    emit(state.copyWith(status: RequestStatus.loading, clearMessage: true));
    final result = await _loginUseCase(email: email, password: password);
    result.when(
      success: (_) => emit(state.copyWith(status: RequestStatus.success)),
      failure: (error) => emit(
        state.copyWith(
          status: RequestStatus.failure,
          message: _messageFor(error),
        ),
      ),
    );
  }

  String _messageFor(AuthFailure error) {
    switch (error) {
      case AuthFailure.invalidCredentials:
        return 'Укажите корректный email и пароль.';
      case AuthFailure.unknown:
        return 'Не удалось войти. Попробуйте снова.';
    }
  }
}
