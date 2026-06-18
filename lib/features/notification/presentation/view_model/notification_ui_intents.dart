sealed class NotificationUiIntents {
  const NotificationUiIntents();
}

class NotificationShowErrorIntent extends NotificationUiIntents {
  final String error;
  const NotificationShowErrorIntent({required this.error});
}

class NavigateToPostIntent extends NotificationUiIntents {
  final int postId;
  const NavigateToPostIntent({required this.postId});
}

class NavigateToCommentsIntent extends NotificationUiIntents {
  final int postId;
  const NavigateToCommentsIntent({required this.postId});
}
