abstract class ProfileUiIntents {}

class ShowErrorProfileIntent extends ProfileUiIntents {
  final String message;
  ShowErrorProfileIntent({required this.message});
}
