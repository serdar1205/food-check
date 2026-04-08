import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/application/request_status.dart';
import '../../../core/constants/splash_constants.dart';
import 'check_authorization_use_case.dart';
import 'splash_destination.dart';

class SplashState {
  const SplashState({required this.status, this.destination});

  const SplashState.initial() : status = RequestStatus.idle, destination = null;

  final RequestStatus status;
  final SplashDestination? destination;

  SplashState copyWith({
    RequestStatus? status,
    SplashDestination? destination,
  }) {
    return SplashState(
      status: status ?? this.status,
      destination: destination ?? this.destination,
    );
  }
}

class SplashCubit extends Cubit<SplashState> {
  SplashCubit(
    this._checkAuthorization, {
    Duration minDisplayDuration = SplashConstants.minDisplayDuration,
  }) : _minDisplayDuration = minDisplayDuration,
       super(const SplashState.initial());

  final CheckAuthorizationUseCase _checkAuthorization;
  final Duration _minDisplayDuration;

  Future<void> initialize() async {
    emit(state.copyWith(status: RequestStatus.loading));
    final stopwatch = Stopwatch()..start();
    final authorized = await _checkAuthorization();
    final remaining = _minDisplayDuration - stopwatch.elapsed;
    if (remaining > Duration.zero) {
      await Future<void>.delayed(remaining);
    }
    emit(
      state.copyWith(
        status: RequestStatus.success,
        destination: authorized
            ? SplashDestination.authorized
            : SplashDestination.unauthorized,
      ),
    );
  }
}
