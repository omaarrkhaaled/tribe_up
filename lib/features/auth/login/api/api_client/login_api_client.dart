import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:tribe_up/core/constants/api_constants.dart';
import 'package:tribe_up/features/auth/login/data/models/login_request/login_request_model.dart';
import 'package:tribe_up/features/auth/login/data/models/login_request/refresh_token_request_model.dart';
import 'package:tribe_up/features/auth/login/data/models/login_response/login_response_model.dart';
part 'login_api_client.g.dart';

@injectable
@RestApi()
abstract class LoginApiClient {
  @factoryMethod
  factory LoginApiClient(Dio dio) = _LoginApiClient;

  @POST(ApiConstants.loginEndPoint)
  Future<LoginResponseModel> login(@Body() LoginRequestModel loginRequest);

  @POST(ApiConstants.refreshEndPoint)
  Future<LoginResponseModel> refreshToken(
    @Body() RefreshTokenRequestModel refreshTokenRequest,
  );
}
