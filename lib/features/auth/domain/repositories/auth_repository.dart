import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/auth/domain/entities/change_password_request_entity.dart';
import 'package:tribe_up/features/auth/domain/entities/forget_password_request_entity.dart';
import 'package:tribe_up/features/auth/domain/entities/login_request/login_request_entity.dart';
import 'package:tribe_up/features/auth/domain/entities/login_response/login_response_entity.dart';
import 'package:tribe_up/features/auth/domain/entities/sign_up_request/sign_up_request_entity.dart';
import 'package:tribe_up/features/auth/domain/entities/sign_up_response/sign_up_response_entity.dart';

abstract class AuthRepository {
  Future<BaseResponse<void>> changePassword(
    ChangePasswordRequestEntity request,
  );
  Future<BaseResponse<void>> forgetPassword(
    ForgetPasswordRequestEntity request,
  );
  Future<BaseResponse<LoginResponseEntity>> login(
    LoginRequestEntity requestEntity,
  );
  Future<BaseResponse<LoginResponseEntity>> refreshToken({
    required String refreshToken,
    required String deviceId,
  });
  Future<BaseResponse<void>> logout();
  Future<BaseResponse<SignUpResponseEntity>> signUp(
    SignUpRequestEntity requestEntity,
  );
}
