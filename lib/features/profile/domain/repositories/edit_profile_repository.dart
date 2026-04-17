import 'dart:io';

import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/profile/data/models/request/update_name_request.dart';
import 'package:tribe_up/features/profile/domain/entities/profile_entity.dart';

abstract interface class EditProfileRepository {
  Future<BaseResponse<ProfileInfoEntity>> getProfileInfo();
  Future<BaseResponse<void>> updateName(UpdateNameRequest request);
  Future<BaseResponse<void>> updateAvatar(String? avatar);
  Future<BaseResponse<void>> updateBio(String? bio);
  Future<BaseResponse<void>> updatePhone(String? phone);
  Future<BaseResponse<void>> updatePicture(File? picture);
  Future<BaseResponse<void>> updateCover(File? cover);
  Future<BaseResponse<void>> deleteBio();
  Future<BaseResponse<void>> deletePhone();
  Future<BaseResponse<void>> deletePicture();
  Future<BaseResponse<void>> deleteCover();
}
