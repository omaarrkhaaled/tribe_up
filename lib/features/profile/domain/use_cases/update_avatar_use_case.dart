import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/profile/domain/repositories/profile_repositoriy.dart';

@lazySingleton
class UpdateAvatarUseCase {
  final ProfileRepositoriy repositoriy;

  UpdateAvatarUseCase(this.repositoriy);
  Future<BaseResponse<void>> call(String? avatar) async {
    return await repositoriy.updateAvatar(avatar);
  }
}
