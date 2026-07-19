abstract class ProfileUiIntents {}

class ShowErrorProfileIntent extends ProfileUiIntents {
  final String message;
  ShowErrorProfileIntent({required this.message});
}

class ShowSuccessProfileIntent extends ProfileUiIntents {
  final String message;
  ShowSuccessProfileIntent({required this.message});
}
