import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/application/request_status.dart';
import '../../auth/domain/auth_repository.dart';
import '../domain/user_profile.dart';
import 'get_profile_use_case.dart';

class ProfileState {
  const ProfileState({required this.status, this.profile});

  const ProfileState.initial() : status = RequestStatus.idle, profile = null;

  final RequestStatus status;
  final UserProfile? profile;

  ProfileState copyWith({RequestStatus? status, UserProfile? profile}) {
    return ProfileState(
      status: status ?? this.status,
      profile: profile ?? this.profile,
    );
  }
}

class ProfileCubit extends Cubit<ProfileState> {
  ProfileCubit(this._getProfile, this._authRepository)
    : super(const ProfileState.initial());

  final GetProfileUseCase _getProfile;
  final AuthRepository _authRepository;

  Future<void> load() async {
    emit(state.copyWith(status: RequestStatus.loading));
    final result = await _getProfile();
    result.when(
      success: (profile) =>
          emit(state.copyWith(status: RequestStatus.success, profile: profile)),
      failure: (_) => emit(state.copyWith(status: RequestStatus.failure)),
    );
  }

  Future<void> logout() => _authRepository.logout();
}
