import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/auth/change_password/domain/entities/change_password_request_entity.dart';

abstract class ChangePasswordRepo {
  Future<BaseResponse<void>> changePassword(
    ChangePasswordRequestEntity request,
  );
}