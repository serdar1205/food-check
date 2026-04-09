import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/application/request_status.dart';
import '../domain/activated_coupon.dart';
import '../domain/reward_offer.dart';
import '../domain/rewards_failure.dart';
import '../domain/rewards_repository.dart';

class RewardsListState {
  const RewardsListState({
    required this.status,
    this.offers = const <RewardOffer>[],
    this.errorMessage,
  });

  final RequestStatus status;
  final List<RewardOffer> offers;
  final String? errorMessage;

  RewardsListState copyWith({
    RequestStatus? status,
    List<RewardOffer>? offers,
    String? errorMessage,
    bool clearErrorMessage = false,
  }) {
    return RewardsListState(
      status: status ?? this.status,
      offers: offers ?? this.offers,
      errorMessage: clearErrorMessage
          ? null
          : (errorMessage ?? this.errorMessage),
    );
  }
}

class RewardsListCubit extends Cubit<RewardsListState> {
  RewardsListCubit(this._repository)
    : super(const RewardsListState(status: RequestStatus.idle));

  final RewardsRepository _repository;

  Future<void> load() async {
    emit(
      state.copyWith(status: RequestStatus.loading, clearErrorMessage: true),
    );
    try {
      final list = await _repository.listOffers();
      emit(RewardsListState(status: RequestStatus.success, offers: list));
    } on Object catch (_) {
      emit(
        const RewardsListState(
          status: RequestStatus.failure,
          errorMessage: 'Не удалось загрузить награды',
        ),
      );
    }
  }

  void clearRedeemMessage() {
    emit(state.copyWith(clearErrorMessage: true));
  }

  Future<ActivatedCoupon?> redeem(String offerId) async {
    final result = await _repository.redeem(offerId);
    return result.when(
      success: (ActivatedCoupon c) => c,
      failure: (RewardsFailure f) {
        final msg = switch (f) {
          RewardsFailure.insufficientBalance => 'Недостаточно бонусных баллов',
          RewardsFailure.offerNotFound => 'Награда не найдена',
          RewardsFailure.unknown => 'Не удалось обменять',
        };
        emit(state.copyWith(errorMessage: msg));
        return null;
      },
    );
  }
}
