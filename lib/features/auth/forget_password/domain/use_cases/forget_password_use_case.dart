import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/auth/forget_password/domain/entities/forget_password_request_entity.dart';
import 'package:tribe_up/features/auth/forget_password/domain/repositories/foreget_password_repositoy.dart';

@injectable
class ForgetPasswordUseCase {
  final ForgetPasswordRepository _forgetPasswordRepository;

  const ForgetPasswordUseCase(this._forgetPasswordRepository);

  Future<BaseResponse<void>> call(ForgetPasswordRequestEntity request) {
    return _forgetPasswordRepository.forgetPassword(request);
  }
}
