import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/edit_profile/domain/entities/edit_profile_entity.dart';
import 'package:tribe_up/features/edit_profile/domain/repositories/edit_profile_repository.dart';

@lazySingleton
class GetProfileInfoUseCase {
  final EditProfileRepository repositoriy;

  GetProfileInfoUseCase(this.repositoriy);
  Future<BaseResponse<ProfileInfoEntity>> call() async {
    return await repositoriy.getProfileInfo();
  }
}
