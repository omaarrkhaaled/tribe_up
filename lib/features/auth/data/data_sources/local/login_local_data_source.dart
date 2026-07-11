import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/auth/data/models/login_response/user_summary_model.dart';

abstract class LoginLocalDataSource {
  Future<BaseResponse<void>> saveTokens({
    required String token,
    required String refreshToken,
  });

  Future<String?> getAccessToken();

  Future<String?> getRefreshToken();

  Future<BaseResponse<void>> saveUserSummary({
    required UserSummaryModel userSummary,
  });

  Future<UserSummaryModel?> getUserSummary();

  Future<void> clearTokens();

  Future<void> clearUserSummary();
}
