import 'package:tribe_up/config/base_response/base_response.dart';

abstract class LoginLocalDataSource {
  Future<BaseResponse<void>> saveTokens({
    required String token,
    required String refreshToken,
  });

  Future<String?> getAccessToken();

  Future<String?> getRefreshToken();

  Future<void> clearTokens();
}
