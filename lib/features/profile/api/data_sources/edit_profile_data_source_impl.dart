import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/core/network/api_call.dart';
import 'package:tribe_up/features/profile/api/api_client/edit_profile_api_client.dart';
import 'package:tribe_up/features/profile/data/data_sorces/edit_profile_data_source.dart';
import 'package:tribe_up/features/profile/data/models/request/update_name_request.dart';
import 'package:tribe_up/features/profile/data/models/response/profile_info_response.dart';

@LazySingleton(as: EditProfileDataSource)
class EditProfileDataSourceImpl implements EditProfileDataSource {
  final EditProfileApiClient _apiClient;
  EditProfileDataSourceImpl(this._apiClient);
  @override
  Future<BaseResponse<ProfileInfoResponse>> getProfileInfo() {
    return safeApiCall(() => _apiClient.getProfileInfo());
  }

  @override
  Future<BaseResponse<void>> updateName(UpdateNameRequest request) {
    return safeApiCall(() => _apiClient.updateName(request));
  }

  @override
  Future<BaseResponse<void>> updateAvatar(String? avatar) {
    return safeApiCall(() => _apiClient.updateAvatar(avatar));
  }

  @override
  Future<BaseResponse<void>> updateBio(String? bio) {
    return safeApiCall(() => _apiClient.updateBio(bio));
  }

  @override
  Future<BaseResponse<void>> updatePhone(String? phone) {
    return safeApiCall(() => _apiClient.updatePhone(phone));
  }

  @override
  Future<BaseResponse<void>> updatePicture(File? picture) {
    return safeApiCall(() => _apiClient.updatePicture(picture));
  }

  @override
  Future<BaseResponse<void>> updateCover(File? cover) {
    return safeApiCall(() => _apiClient.updateCover(cover));
  }

  @override
  Future<BaseResponse<void>> deleteBio() {
    return safeApiCall(() => _apiClient.deleteBio());
  }

  @override
  Future<BaseResponse<void>> deletePhone() {
    return safeApiCall(() => _apiClient.deletePhone());
  }

  @override
  Future<BaseResponse<void>> deletePicture() {
    return safeApiCall(() => _apiClient.deletePicture());
  }

  @override
  Future<BaseResponse<void>> deleteCover() {
    return safeApiCall(() => _apiClient.deleteCover());
  }
}
