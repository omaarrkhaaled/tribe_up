import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/auth/sign_up/domain/entities/sign_up_request/sign_up_request_entity.dart';
import 'package:tribe_up/features/auth/sign_up/domain/entities/sign_up_response/sign_up_response_entity.dart';

abstract class SignUpRepository {
  Future<BaseResponse<SignUpResponseEntity>> signUp(
    SignUpRequestEntity requestEntity,
  );
}
