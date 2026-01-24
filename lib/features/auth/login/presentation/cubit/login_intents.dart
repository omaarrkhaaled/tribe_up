sealed class LoginIntents {}

class EmailChanged extends LoginIntents {
  final String email;
  EmailChanged(this.email);
}

class PasswordChanged extends LoginIntents {
  final String password;
  PasswordChanged(this.password);
}

class LoginIntent extends LoginIntents {}
