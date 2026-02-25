import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/auth/sign_up/domain/entities/sign_up_request/sign_up_request_entity.dart';
import 'package:tribe_up/features/auth/sign_up/domain/entities/sign_up_response/sign_up_response_entity.dart';
import 'package:tribe_up/features/auth/sign_up/domain/repository/sign_up_repositiry.dart';

@injectable
class SignUpUseCase {
  final SignUpRepository repository;

  SignUpUseCase(this.repository);

  Future<BaseResponse<SignUpResponseEntity>> call(
    SignUpRequestEntity requestEntity,
  ) {
    return repository.signUp(requestEntity);
  }
}
