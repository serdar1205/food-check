import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/application/request_status.dart';
import '../domain/partner_analytics_repository.dart';
import '../domain/partner_kpi_snapshot.dart';

class PartnerDashboardState {
  const PartnerDashboardState({
    required this.status,
    this.snapshot,
    this.message,
  });

  const PartnerDashboardState.initial()
    : status = RequestStatus.idle,
      snapshot = null,
      message = null;

  final RequestStatus status;
  final PartnerKpiSnapshot? snapshot;
  final String? message;
}

class PartnerDashboardCubit extends Cubit<PartnerDashboardState> {
  PartnerDashboardCubit(this._repository)
    : super(const PartnerDashboardState.initial());

  final PartnerAnalyticsRepository _repository;

  Future<void> load() async {
    emit(const PartnerDashboardState(status: RequestStatus.loading));
    try {
      final data = await _repository.getDashboard();
      emit(
        PartnerDashboardState(status: RequestStatus.success, snapshot: data),
      );
    } on Object catch (_) {
      emit(
        const PartnerDashboardState(
          status: RequestStatus.failure,
          message: 'Не удалось загрузить аналитику',
        ),
      );
    }
  }
}
