import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/profile/data/models/response/profile_response.dart';

abstract class ProfileDataSource {
  Future<BaseResponse<ProfileResponse>> getUserProfile(String userName);
}
