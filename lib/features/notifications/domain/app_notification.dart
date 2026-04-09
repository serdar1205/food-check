import 'notification_type.dart';

class AppNotification {
  const AppNotification({
    required this.id,
    required this.title,
    required this.body,
    required this.createdAt,
    required this.read,
    required this.type,
  });

  final String id;
  final String title;
  final String body;
  final DateTime createdAt;
  final bool read;
  final AppNotificationType type;
}
