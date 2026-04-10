import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/application/request_status.dart';
import '../domain/partner_branch.dart';
import '../domain/partner_branches_repository.dart';

class PartnerBranchesState {
  const PartnerBranchesState({
    required this.status,
    this.items = const [],
    this.message,
  });

  final RequestStatus status;
  final List<PartnerBranch> items;
  final String? message;
}

class PartnerBranchesCubit extends Cubit<PartnerBranchesState> {
  PartnerBranchesCubit(this._repository)
    : super(const PartnerBranchesState(status: RequestStatus.idle));

  final PartnerBranchesRepository _repository;

  Future<void> load() async {
    emit(const PartnerBranchesState(status: RequestStatus.loading));
    try {
      final items = await _repository.listBranches();
      emit(PartnerBranchesState(status: RequestStatus.success, items: items));
    } on Object catch (_) {
      emit(
        const PartnerBranchesState(
          status: RequestStatus.failure,
          message: 'Не удалось загрузить филиалы',
        ),
      );
    }
  }
}
