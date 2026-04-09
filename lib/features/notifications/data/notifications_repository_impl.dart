import '../domain/app_notification.dart';
import '../domain/notification_type.dart';
import '../domain/notifications_repository.dart';

class NotificationsRepositoryImpl implements NotificationsRepository {
  @override
  Future<List<AppNotification>> listNotifications() async {
    return <AppNotification>[
      AppNotification(
        id: 'n1',
        title: 'Начислены бонусы',
        body: '+50 баллов за отзыв в «Пиццерия Наполи».',
        createdAt: DateTime(2026, 4, 2, 10, 20),
        read: false,
        type: AppNotificationType.bonusCredit,
      ),
      AppNotification(
        id: 'n2',
        title: 'Купон использован',
        body: 'Скидка 10% применена в «Суши-бар Токио».',
        createdAt: DateTime(2026, 4, 1, 18, 5),
        read: true,
        type: AppNotificationType.couponUsed,
      ),
      AppNotification(
        id: 'n3',
        title: 'Акция выходного дня',
        body: 'Двойные бонусные баллы за отзывы до воскресенья.',
        createdAt: DateTime(2026, 3, 28, 9, 0),
        read: false,
        type: AppNotificationType.promotion,
      ),
      AppNotification(
        id: 'n4',
        title: 'Обновление приложения',
        body: 'Добавлен раздел купонов и история бонусов.',
        createdAt: DateTime(2026, 3, 20, 12, 0),
        read: true,
        type: AppNotificationType.system,
      ),
    ];
  }
}
