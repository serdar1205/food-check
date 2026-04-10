import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/application/request_status.dart';
import '../domain/partner_quality_alerts_repository.dart';
import '../domain/quality_alert.dart';

class PartnerQualityAlertsState {
  const PartnerQualityAlertsState({
    required this.status,
    this.items = const [],
    this.message,
  });

  final RequestStatus status;
  final List<QualityAlert> items;
  final String? message;
}

class PartnerQualityAlertsCubit extends Cubit<PartnerQualityAlertsState> {
  PartnerQualityAlertsCubit(this._repository)
    : super(const PartnerQualityAlertsState(status: RequestStatus.idle));

  final PartnerQualityAlertsRepository _repository;

  Future<void> load() async {
    emit(const PartnerQualityAlertsState(status: RequestStatus.loading));
    try {
      final items = await _repository.listAlerts();
      emit(
        PartnerQualityAlertsState(status: RequestStatus.success, items: items),
      );
    } on Object catch (_) {
      emit(
        const PartnerQualityAlertsState(
          status: RequestStatus.failure,
          message: 'Не удалось загрузить уведомления',
        ),
      );
    }
  }
}
