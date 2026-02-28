import 'package:tribe_up/features/auth/login/domain/entities/login_response/user_summary_entity.dart';

class LoginResponseEntity {
  final String? accessToken;
  final String? refreshToken;
  final UserSummaryEntity? userSummary;

  const LoginResponseEntity({
    this.accessToken,
    this.refreshToken,
    this.userSummary,
  });
}
