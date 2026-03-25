import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/profile/domain/entities/user_profile_entity.dart';
import 'package:tribe_up/features/profile/domain/repositories/profile_repositoriy.dart';

@lazySingleton
class GetUserProfileUseCase {
  final ProfileRepositoriy repositoriy;

  GetUserProfileUseCase(this.repositoriy);
  Future<BaseResponse<UserProfileEntity>> call({
    required String userName,
  }) async {
    return await repositoriy.getUserProfile(userName: userName);
  }
}
