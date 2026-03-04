import 'package:tribe_up/features/auth/login/domain/entities/login_response/user_summary_entity.dart';

sealed class LoginUiIntent {
  const LoginUiIntent();
}

class ShowLoadingIntent extends LoginUiIntent {}

class ShowErrorIntent extends LoginUiIntent {
  final String message;

  const ShowErrorIntent({required this.message});
}

class NavigateToFeedIntent extends LoginUiIntent {
  final UserSummaryEntity? userSummary;
  const NavigateToFeedIntent(this.userSummary);
}
