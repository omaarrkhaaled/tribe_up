import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:tribe_up/core/constants/api_constants.dart';
import 'package:tribe_up/features/auth/data/models/change_password_request.dart';
part 'change_password_api_client.g.dart';

@injectable
@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class ChangePasswordApiClient {
  @factoryMethod
  factory ChangePasswordApiClient(Dio dio) = _ChangePasswordApiClient;

  @POST(ApiConstants.changePassordEndPOint)
  Future<void> changePassword(@Body() ChangePasswordRequest request);
}
