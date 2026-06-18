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
  final int? referenceId;
  final String? type;
  const ReadNotificationIntent({required this.id, this.referenceId, this.type});
}

class ReadAllNotificationsIntent extends NotificationIntents {
  const ReadAllNotificationsIntent();
}
