import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/auth/domain/entities/forget_password_request_entity.dart';
import 'package:tribe_up/features/auth/domain/repositories/auth_repository.dart';

@injectable
class ForgetPasswordUseCase {
  final AuthRepository authRepository;

  const ForgetPasswordUseCase(this.authRepository);

  Future<BaseResponse<void>> call(ForgetPasswordRequestEntity request) {
    return authRepository.forgetPassword(request);
  }
}
