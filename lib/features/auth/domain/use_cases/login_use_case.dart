import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/auth/domain/entities/login_request/login_request_entity.dart';
import 'package:tribe_up/features/auth/domain/entities/login_response/login_response_entity.dart';
import 'package:tribe_up/features/auth/domain/repositories/auth_repository.dart';

@injectable
class LoginUseCase {
  final AuthRepository repository;

  LoginUseCase(this.repository);

  Future<BaseResponse<LoginResponseEntity>> call(
    LoginRequestEntity requestEntity,
  ) {
    return repository.login(requestEntity);
  }
}
