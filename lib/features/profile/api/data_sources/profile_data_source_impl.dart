import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/core/network/api_call.dart';
import 'package:tribe_up/features/profile/api/api_client/profile_api_client.dart';
import 'package:tribe_up/features/profile/data/response/profile_response.dart';
import 'package:tribe_up/features/profile/data_source/profile_data_source.dart';

@LazySingleton(as: ProfileDataSource)
class ProfileDataSourceImpl implements ProfileDataSource {
  final ProfileApiClient _apiClient;

  ProfileDataSourceImpl(this._apiClient);

  @override
  Future<BaseResponse<ProfileResponse>> getUserProfile(String userName) {
    return safeApiCall(() => _apiClient.getUserProfile(userName));
  }
}
