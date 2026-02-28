import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/auth/forget_password/domain/entities/forget_password_request_entity.dart';

abstract class ForgetPasswordRepository {
  Future<BaseResponse<void>> forgetPassword(
    ForgetPasswordRequestEntity request,
  );
}
