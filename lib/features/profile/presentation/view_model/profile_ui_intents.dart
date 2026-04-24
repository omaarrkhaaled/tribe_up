abstract class ProfileUiIntents {}

class NavigateToEditProfileIntent extends ProfileUiIntents {}

class ShowErrorProfileIntent extends ProfileUiIntents {
  final String message;
  ShowErrorProfileIntent({required this.message});
}
