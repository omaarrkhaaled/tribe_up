sealed class ForgetPasswordIntents {}

class EmailChangedIntent extends ForgetPasswordIntents {
  final String email;
  EmailChangedIntent(this.email);
}

class ConfirmEmailIntent extends ForgetPasswordIntents {}

class ResendLinkIntent extends ForgetPasswordIntents {
  final String? email;
  ResendLinkIntent({this.email});
}
