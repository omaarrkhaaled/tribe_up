import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/auth/change_password/domain/entities/change_password_request_entity.dart';
import 'package:tribe_up/features/auth/change_password/domain/repository/change_password_repo.dart';

@injectable
class ChangePasswordUseCase {
  final ChangePasswordRepo _repo;
  ChangePasswordUseCase(this._repo);
  Future<BaseResponse<void>> call(ChangePasswordRequestEntity request) =>
      _repo.changePassword(request);
}
