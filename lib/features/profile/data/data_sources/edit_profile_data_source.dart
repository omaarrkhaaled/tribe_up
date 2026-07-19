import 'dart:io';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/profile/data/models/request/update_name_request.dart';
import 'package:tribe_up/features/profile/data/models/request/update_avatar_request.dart';
import 'package:tribe_up/features/profile/data/models/request/update_bio_request.dart';
import 'package:tribe_up/features/profile/data/models/request/update_phone_request.dart';
import 'package:tribe_up/features/profile/data/models/response/profile_info_response.dart';

abstract class EditProfileDataSource {
  Future<BaseResponse<ProfileInfoResponse>> getProfileInfo();
  Future<BaseResponse<void>> updateName(UpdateNameRequest request);
  Future<BaseResponse<void>> updateAvatar(UpdateAvatarRequest request);
  Future<BaseResponse<void>> updateBio(UpdateBioRequest request);
  Future<BaseResponse<void>> updatePhone(UpdatePhoneRequest request);
  Future<BaseResponse<void>> updatePicture(File? picture);
  Future<BaseResponse<void>> updateCover(File? cover);
  Future<BaseResponse<void>> deleteBio();
  Future<BaseResponse<void>> deletePhone();
  Future<BaseResponse<void>> deletePicture();
  Future<BaseResponse<void>> deleteCover();
}
