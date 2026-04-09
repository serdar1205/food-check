import 'app_notification.dart';

abstract interface class NotificationsRepository {
  Future<List<AppNotification>> listNotifications();
}
