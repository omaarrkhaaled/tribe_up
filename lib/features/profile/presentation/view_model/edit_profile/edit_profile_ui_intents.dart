sealed class EditProfileUiIntents {}

class ShowErrorIntent extends EditProfileUiIntents {
  final String errorMessage;
  ShowErrorIntent({required this.errorMessage});
}

class ShowSuccessIntent extends EditProfileUiIntents {
  final String message;
  ShowSuccessIntent({required this.message});
}

class DismissDialogIntent extends EditProfileUiIntents {}
