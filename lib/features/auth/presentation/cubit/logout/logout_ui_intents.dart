sealed class LogoutUiIntents {}

class ShowLoadingIntents extends LogoutUiIntents {}

class ShowErrorIntents extends LogoutUiIntents {
  final String message;

  ShowErrorIntents(this.message);
}

class NavigateToLoginIntent extends LogoutUiIntents {}
