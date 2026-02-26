import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/auth/login/data/models/login_request/login_request_model.dart';
import 'package:tribe_up/features/auth/login/data/models/login_request/refresh_token_request_model.dart';
import 'package:tribe_up/features/auth/login/data/models/login_response/login_response_model.dart';

abstract class LoginRemoteDataSource {
  Future<BaseResponse<LoginResponseModel>> login(LoginRequestModel request);

  Future<BaseResponse<LoginResponseModel>> refreshToken(
    RefreshTokenRequestModel request,
  );
}
