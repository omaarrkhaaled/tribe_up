import 'package:injectable/injectable.dart';
import 'package:retrofit/retrofit.dart';
import 'package:tribe_up/core/constants/api_constants.dart';
import 'package:dio/dio.dart';

part 'logout_api_client.g.dart';

@injectable
@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class LogoutApiClient {
  @factoryMethod
  factory LogoutApiClient(Dio dio) = _LogoutApiClient;

  @POST(ApiConstants.logoutEndPoint)
  Future<void> logout();
}
