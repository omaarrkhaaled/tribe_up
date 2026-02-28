sealed class SignUpUiIntent {
  const SignUpUiIntent();
}

class ShowLoadingIntent extends SignUpUiIntent {}

class ShowErrorIntent extends SignUpUiIntent {
  final String message;

  const ShowErrorIntent({required this.message});
}

class NavigateToLoginIntent extends SignUpUiIntent {
  final String message;
  const NavigateToLoginIntent({required this.message});
}
