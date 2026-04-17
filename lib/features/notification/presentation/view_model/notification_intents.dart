sealed class NotificationIntents {
  const NotificationIntents();
}

class GetNotificationsIntent extends NotificationIntents {
  const GetNotificationsIntent();
}

class LoadMoreNotificationsIntent extends NotificationIntents {
  const LoadMoreNotificationsIntent();
}

class ReadNotificationIntent extends NotificationIntents {
  final int id;
  const ReadNotificationIntent({required this.id});
}

class ReadAllNotificationsIntent extends NotificationIntents {
  const ReadAllNotificationsIntent();
}
