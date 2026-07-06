import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/auth/domain/entities/change_password_request_entity.dart';
import 'package:tribe_up/features/auth/domain/repositories/auth_repository.dart';

@injectable
class ChangePasswordUseCase {
  final AuthRepository _repo;
  ChangePasswordUseCase(this._repo);
  Future<BaseResponse<void>> call(ChangePasswordRequestEntity request) =>
      _repo.changePassword(request);
}
