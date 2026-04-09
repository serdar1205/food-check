import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/application/request_status.dart';
import '../../../core/errors/app_failures.dart';
import '../../profile/application/get_profile_use_case.dart';
import '../../profile/domain/user_profile.dart';
import '../domain/bonus_ledger_entry.dart';
import '../domain/bonus_wallet_repository.dart';

class BonusWalletState {
  const BonusWalletState({
    required this.status,
    this.entries = const <BonusLedgerEntry>[],
    this.currentBalance,
    this.errorMessage,
  });

  final RequestStatus status;
  final List<BonusLedgerEntry> entries;
  final int? currentBalance;
  final String? errorMessage;

  BonusWalletState copyWith({
    RequestStatus? status,
    List<BonusLedgerEntry>? entries,
    int? currentBalance,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return BonusWalletState(
      status: status ?? this.status,
      entries: entries ?? this.entries,
      currentBalance: currentBalance ?? this.currentBalance,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }
}

class BonusWalletCubit extends Cubit<BonusWalletState> {
  BonusWalletCubit(this._wallet, this._getProfileUseCase)
    : super(const BonusWalletState(status: RequestStatus.idle));

  final BonusWalletRepository _wallet;
  final GetProfileUseCase _getProfileUseCase;

  Future<void> load() async {
    emit(
      state.copyWith(status: RequestStatus.loading, clearErrorMessage: true),
    );
    try {
      final entries = await _wallet.listEntries();
      final profileResult = await _getProfileUseCase();
      final balance = profileResult.when(
        success: (UserProfile p) => p.bonusBalance,
        failure: (ProfileFailure _) => null,
      );
      if (balance == null) {
        emit(
          const BonusWalletState(
            status: RequestStatus.failure,
            errorMessage: 'Не удалось загрузить баланс',
          ),
        );
        return;
      }
      emit(
        BonusWalletState(
          status: RequestStatus.success,
          entries: entries,
          currentBalance: balance,
        ),
      );
    } on Object catch (_) {
      emit(
        const BonusWalletState(
          status: RequestStatus.failure,
          errorMessage: 'Не удалось загрузить операции',
        ),
      );
    }
  }
}
