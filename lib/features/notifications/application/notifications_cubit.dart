import 'package:flutter_bloc/flutter_bloc.dart';

import '../../../core/application/request_status.dart';
import '../domain/app_notification.dart';
import '../domain/notifications_repository.dart';

class NotificationsState {
  const NotificationsState({
    required this.status,
    this.items = const <AppNotification>[],
    this.errorMessage,
  });

  final RequestStatus status;
  final List<AppNotification> items;
  final String? errorMessage;
}

class NotificationsCubit extends Cubit<NotificationsState> {
  NotificationsCubit(this._repository)
    : super(const NotificationsState(status: RequestStatus.idle));

  final NotificationsRepository _repository;

  Future<void> load() async {
    emit(const NotificationsState(status: RequestStatus.loading));
    try {
      final list = await _repository.listNotifications();
      emit(NotificationsState(status: RequestStatus.success, items: list));
    } on Object catch (_) {
      emit(
        const NotificationsState(
          status: RequestStatus.failure,
          errorMessage: 'Не удалось загрузить уведомления',
        ),
      );
    }
  }
}
