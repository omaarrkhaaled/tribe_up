import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/auth/login/domain/entities/login_request/login_request_entity.dart';
import 'package:tribe_up/features/auth/login/domain/entities/login_response/login_response_entity.dart';

abstract class LoginRepositiry {
  Future<BaseResponse<LoginResponseEntity>> login(LoginRequestEntity requestEntity);
}
