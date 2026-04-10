import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/application/request_status.dart';
import '../domain/partner_branch_details.dart';
import '../domain/partner_branches_repository.dart';

class PartnerBranchDetailsState {
  const PartnerBranchDetailsState({
    required this.status,
    this.details,
    this.message,
    this.period = '30d',
  });

  final RequestStatus status;
  final PartnerBranchDetails? details;
  final String? message;
  final String period;

  PartnerBranchDetailsState copyWith({
    RequestStatus? status,
    PartnerBranchDetails? details,
    String? message,
    String? period,
  }) {
    return PartnerBranchDetailsState(
      status: status ?? this.status,
      details: details ?? this.details,
      message: message ?? this.message,
      period: period ?? this.period,
    );
  }
}

class PartnerBranchDetailsCubit extends Cubit<PartnerBranchDetailsState> {
  PartnerBranchDetailsCubit(this._repository)
    : super(const PartnerBranchDetailsState(status: RequestStatus.idle));

  final PartnerBranchesRepository _repository;

  Future<void> load(String branchId) async {
    emit(state.copyWith(status: RequestStatus.loading));
    final details = await _repository.getDetails(branchId);
    if (details == null) {
      emit(
        state.copyWith(
          status: RequestStatus.failure,
          message: 'Филиал не найден',
        ),
      );
      return;
    }
    emit(state.copyWith(status: RequestStatus.success, details: details));
  }

  void setPeriod(String period) {
    emit(state.copyWith(period: period));
  }
}
