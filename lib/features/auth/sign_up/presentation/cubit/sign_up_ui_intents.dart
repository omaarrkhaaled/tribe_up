sealed class SignUpUiIntent {
  const SignUpUiIntent();
}

class ShowLoadingIntent extends SignUpUiIntent {}

class ShowErrorIntent extends SignUpUiIntent {
  final String message;

  const ShowErrorIntent({required this.message});
}

class NavigateToFeedIntent extends SignUpUiIntent {
  final String message;
  const NavigateToFeedIntent({required this.message});
}
