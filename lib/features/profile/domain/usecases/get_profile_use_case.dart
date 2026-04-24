import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/profile/domain/entities/profile_entity.dart';
import 'package:tribe_up/features/profile/domain/repository/profile_repository.dart';

@lazySingleton
class GetProfileUseCase {
  final ProfileRepository repository;

  GetProfileUseCase(this.repository);

  Future<BaseResponse<ProfileEntity>> call(String userName) async {
    return await repository.getUserProfile(userName);
  }
}
