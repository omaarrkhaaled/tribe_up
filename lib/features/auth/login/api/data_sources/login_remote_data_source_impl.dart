import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/core/errors/exception.dart';
import 'package:tribe_up/features/auth/login/api/api_client/login_api_client.dart';
import 'package:tribe_up/features/auth/login/data/data_sources/login_remote_data_source.dart';
import 'package:tribe_up/features/auth/login/data/models/login_request/login_request_model.dart';
import 'package:tribe_up/features/auth/login/data/models/login_request/refresh_token_request_model.dart';
import 'package:tribe_up/features/auth/login/data/models/login_response/login_response_model.dart';

@Injectable(as: LoginRemoteDataSource)
class LoginRemoteDataSourceImpl implements LoginRemoteDataSource {
  LoginApiClient apiClient;
  LoginRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<BaseResponse<LoginResponseModel>> login(
    LoginRequestModel request,
  ) async {
    try {
      LoginResponseModel response = await apiClient.login(request);
      return SuccessResponse<LoginResponseModel>(data: response);
    } catch (e) {
      return ErrorResponse<LoginResponseModel>(
        error: RemoteException.fromDioError(e as Exception),
      );
    }
  }

  @override
  Future<BaseResponse<LoginResponseModel>> refreshToken(
    RefreshTokenRequestModel request,
  ) async {
    try {
      LoginResponseModel response = await apiClient.refreshToken(request);
      return SuccessResponse<LoginResponseModel>(data: response);
    } catch (e) {
      return ErrorResponse<LoginResponseModel>(
        error: RemoteException.fromDioError(e as Exception),
      );
    }
  }
}
