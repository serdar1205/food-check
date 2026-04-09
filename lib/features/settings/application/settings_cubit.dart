import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/application/request_status.dart';
import '../../../core/errors/app_failures.dart';
import '../../profile/application/get_profile_use_case.dart';
import '../../profile/domain/profile_repository.dart';
import '../../profile/domain/user_profile.dart';

class SettingsState {
  const SettingsState({
    required this.loadStatus,
    required this.saveStatus,
    this.displayName = '',
    this.email = '',
    this.errorMessage,
    this.saveErrorMessage,
  });

  final RequestStatus loadStatus;
  final RequestStatus saveStatus;
  final String displayName;
  final String email;
  final String? errorMessage;
  final String? saveErrorMessage;

  SettingsState copyWith({
    RequestStatus? loadStatus,
    RequestStatus? saveStatus,
    String? displayName,
    String? email,
    String? errorMessage,
    String? saveErrorMessage,
    bool clearSaveError = false,
  }) {
    return SettingsState(
      loadStatus: loadStatus ?? this.loadStatus,
      saveStatus: saveStatus ?? this.saveStatus,
      displayName: displayName ?? this.displayName,
      email: email ?? this.email,
      errorMessage: errorMessage ?? this.errorMessage,
      saveErrorMessage: clearSaveError
          ? null
          : (saveErrorMessage ?? this.saveErrorMessage),
    );
  }
}

class SettingsCubit extends Cubit<SettingsState> {
  SettingsCubit(this._getProfile, this._profileRepository)
    : super(
        const SettingsState(
          loadStatus: RequestStatus.idle,
          saveStatus: RequestStatus.idle,
        ),
      );

  final GetProfileUseCase _getProfile;
  final ProfileRepository _profileRepository;

  Future<void> load() async {
    emit(
      state.copyWith(loadStatus: RequestStatus.loading, clearSaveError: true),
    );
    final result = await _getProfile();
    result.when(
      success: (UserProfile p) {
        emit(
          state.copyWith(
            loadStatus: RequestStatus.success,
            displayName: p.name,
            email: p.email,
          ),
        );
      },
      failure: (_) {
        emit(
          state.copyWith(
            loadStatus: RequestStatus.failure,
            errorMessage: 'Не удалось загрузить профиль',
          ),
        );
      },
    );
  }

  void setDisplayNameDraft(String value) {
    emit(state.copyWith(displayName: value));
  }

  Future<bool> saveDisplayName() async {
    emit(
      state.copyWith(saveStatus: RequestStatus.loading, clearSaveError: true),
    );
    final result = await _profileRepository.updateDisplayName(
      state.displayName,
    );
    return result.when(
      success: (_) {
        emit(state.copyWith(saveStatus: RequestStatus.success));
        return true;
      },
      failure: (ProfileFailure e) {
        final msg = e == ProfileFailure.unknown
            ? 'Введите имя'
            : 'Не удалось сохранить';
        emit(
          state.copyWith(
            saveStatus: RequestStatus.failure,
            saveErrorMessage: msg,
          ),
        );
        return false;
      },
    );
  }
}
