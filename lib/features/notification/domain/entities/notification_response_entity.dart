import 'package:tribe_up/features/notification/domain/entities/notification_entity.dart';

class NotificationResponseEntity {
  final List<NotificationEntity>? notifications;
  final int? unreadCount;

  const NotificationResponseEntity({this.notifications, this.unreadCount});

  NotificationResponseEntity copyWith({
    List<NotificationEntity>? notifications,
    int? unreadCount,
  }) {
    return NotificationResponseEntity(
      notifications: notifications ?? this.notifications,
      unreadCount: unreadCount ?? this.unreadCount,
    );
  }
}
