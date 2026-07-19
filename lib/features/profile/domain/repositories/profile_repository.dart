import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/profile/domain/entities/profile_entity.dart';

abstract class ProfileRepository {
  Future<BaseResponse<ProfileEntity>> getUserProfile(String userName);
}
