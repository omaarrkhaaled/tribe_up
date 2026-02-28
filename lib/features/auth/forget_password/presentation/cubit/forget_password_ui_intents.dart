sealed class ForgetPasswordUiIntents {}

class ShowLoadingIntent extends ForgetPasswordUiIntents {}

class ShowErrorIntent extends ForgetPasswordUiIntents {
  final String errorMessage;
  ShowErrorIntent(this.errorMessage);
}

class HideLoadingIntent extends ForgetPasswordUiIntents {}

class NavigateToVerifyIntent extends ForgetPasswordUiIntents {}

class SuccessIntent extends ForgetPasswordUiIntents {
  final String message;
  SuccessIntent(this.message);
}
