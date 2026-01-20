import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/core/errors/exception.dart';
import 'package:tribe_up/features/auth/sign_up/api/api_client/sign_up_api_client.dart';
import 'package:tribe_up/features/auth/sign_up/data/data_sources/sign_up_remote_data_source.dart';
import 'package:tribe_up/features/auth/sign_up/data/models/sign_up_request/sign_up_request_model.dart';
import 'package:tribe_up/features/auth/sign_up/data/models/sign_up_response/sign_up_response_model.dart';

@Injectable(as: SignUpRemoteDataSource)
class SignUpRemoteDataSourceImpl implements SignUpRemoteDataSource {
  SignUpApiClient apiClient;
  SignUpRemoteDataSourceImpl({required this.apiClient});

  @override
  Future<BaseResponse<SignUpResponseModel>> signUp(
    SignUpRequestModel request,
  ) async {
    try {
      SignUpResponseModel response = await apiClient.signUp(request);
      return SuccessResponse<SignUpResponseModel>(data: response);
    } catch (e) {
      return ErrorResponse<SignUpResponseModel>(
        error: RemoteException.fromDioError(e as Exception),
      );
    }
  }
}
