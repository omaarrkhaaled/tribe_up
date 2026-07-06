import 'package:tribe_up/config/base_response/base_response.dart';

abstract class SignUpLocalDataSource {
  Future<BaseResponse<void>> saveTokens({
    required String token,
    required String refreshToken,
  });
}
