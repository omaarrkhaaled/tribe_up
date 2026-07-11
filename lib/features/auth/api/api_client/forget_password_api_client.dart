import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:tribe_up/core/constants/api_constants.dart';
import 'package:tribe_up/features/auth/data/models/forget_password_request.dart';
part 'forget_password_api_client.g.dart';

@injectable
@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class ForgetPasswordApiClient {
  @factoryMethod
  factory ForgetPasswordApiClient(Dio dio) => _ForgetPasswordApiClient(dio);

  @POST(ApiConstants.forgetPasswordEndPoint)
  Future<void> forgetPassword(@Body() ForgetPasswordRequest request);
}
