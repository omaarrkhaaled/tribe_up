sealed class LoginUiIntent {
  const LoginUiIntent();
}

class ShowLoadingIntent extends LoginUiIntent {}

class ShowErrorIntent extends LoginUiIntent {
  final String message;

  const ShowErrorIntent({required this.message});
}

class NavigateToFeedIntent extends LoginUiIntent {
  const NavigateToFeedIntent();
}
