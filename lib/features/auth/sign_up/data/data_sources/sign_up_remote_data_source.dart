import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/auth/sign_up/data/models/sign_up_request/sign_up_request_model.dart';
import 'package:tribe_up/features/auth/sign_up/data/models/sign_up_response/sign_up_response_model.dart';

abstract class SignUpRemoteDataSource {
  Future<BaseResponse<SignUpResponseModel>> signUp(SignUpRequestModel request);
}
