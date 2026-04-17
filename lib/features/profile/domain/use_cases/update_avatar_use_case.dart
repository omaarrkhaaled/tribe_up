import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/profile/domain/repositories/edit_profile_repository.dart';

@lazySingleton
class UpdateAvatarUseCase {
  final EditProfileRepository repositoriy;

  UpdateAvatarUseCase(this.repositoriy);
  Future<BaseResponse<void>> call(String? avatar) async {
    return await repositoriy.updateAvatar(avatar);
  }
}
