import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/profile/domain/entities/profile_entity.dart';
import 'package:tribe_up/features/profile/domain/repositories/profile_repositoriy.dart';

@lazySingleton
class GetProfileInfoUseCase {
  final ProfileRepositoriy repositoriy;

  GetProfileInfoUseCase(this.repositoriy);
  Future<BaseResponse<ProfileInfoEntity>> call() async {
    return await repositoriy.getProfileInfo();
  }
}
