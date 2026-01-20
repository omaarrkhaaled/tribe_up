sealed class SignUpIntents {}

class FirstNameChanged extends SignUpIntents {
  final String firstName;

  FirstNameChanged(this.firstName);
}

class LastNameChanged extends SignUpIntents {
  final String lastName;
  LastNameChanged(this.lastName);
}

class EmailChanged extends SignUpIntents {
  final String email;
  EmailChanged(this.email);
}

class PasswordChanged extends SignUpIntents {
  final String password;
  PasswordChanged(this.password);
}

class ConfirmPasswordChanged extends SignUpIntents {
  final String confirmPassword;
  ConfirmPasswordChanged(this.confirmPassword);
}

class UserNameChanged extends SignUpIntents {
  final String userName;
  UserNameChanged(this.userName);
}

class SignUpIntent extends SignUpIntents {}
