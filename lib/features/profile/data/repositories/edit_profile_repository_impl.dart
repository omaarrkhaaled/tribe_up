import 'dart:io';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/profile/data/data_sorces/edit_profile_data_source.dart';
import 'package:injectable/injectable.dart';
import 'package:tribe_up/features/profile/data/models/request/update_name_request.dart';
import 'package:tribe_up/features/profile/data/models/request/update_avatar_request.dart';
import 'package:tribe_up/features/profile/data/models/request/update_bio_request.dart';
import 'package:tribe_up/features/profile/data/models/request/update_phone_request.dart';
import 'package:tribe_up/features/profile/domain/entities/edit_profile_entity.dart';
import 'package:tribe_up/features/profile/domain/repositories/edit_profile_repository.dart';

@LazySingleton(as: EditProfileRepository)
class EditProfileRepositoryImpl implements EditProfileRepository {
  final EditProfileDataSource dataSource;

  EditProfileRepositoryImpl(this.dataSource);
  @override
  Future<BaseResponse<ProfileInfoEntity>> getProfileInfo() async {
    final response = await dataSource.getProfileInfo();
    switch (response) {
      case SuccessResponse(data: final data):
        return SuccessResponse(data: data.toEntity());
      case ErrorResponse(error: final error):
        return ErrorResponse(error: error);
    }
  }

  @override
  Future<BaseResponse<void>> updateName(UpdateNameRequest request) async {
    final response = await dataSource.updateName(request);
    switch (response) {
      case SuccessResponse():
        return SuccessResponse(data: null);
      case ErrorResponse(error: final error):
        return ErrorResponse(error: error);
    }
  }

  @override
  Future<BaseResponse<void>> updateAvatar(String? avatar) async {
    final response = await dataSource.updateAvatar(
      UpdateAvatarRequest(avatar: avatar ?? ''),
    );
    switch (response) {
      case SuccessResponse():
        return SuccessResponse(data: null);
      case ErrorResponse(error: final error):
        return ErrorResponse(error: error);
    }
  }

  @override
  Future<BaseResponse<void>> updateBio(String? bio) async {
    final response = await dataSource.updateBio(
      UpdateBioRequest(bio: bio ?? ''),
    );
    switch (response) {
      case SuccessResponse():
        return SuccessResponse(data: null);
      case ErrorResponse(error: final error):
        return ErrorResponse(error: error);
    }
  }

  @override
  Future<BaseResponse<void>> updatePhone(String? phone) async {
    final response = await dataSource.updatePhone(
      UpdatePhoneRequest(phoneNumber: phone ?? ''),
    );
    switch (response) {
      case SuccessResponse():
        return SuccessResponse(data: null);
      case ErrorResponse(error: final error):
        return ErrorResponse(error: error);
    }
  }

  @override
  Future<BaseResponse<void>> updatePicture(File? picture) async {
    final response = await dataSource.updatePicture(picture);
    switch (response) {
      case SuccessResponse():
        return SuccessResponse(data: null);
      case ErrorResponse(error: final error):
        return ErrorResponse(error: error);
    }
  }

  @override
  Future<BaseResponse<void>> updateCover(File? cover) async {
    final response = await dataSource.updateCover(cover);
    switch (response) {
      case SuccessResponse():
        return SuccessResponse(data: null);
      case ErrorResponse(error: final error):
        return ErrorResponse(error: error);
    }
  }

  @override
  Future<BaseResponse<void>> deleteBio() async {
    final response = await dataSource.deleteBio();
    switch (response) {
      case SuccessResponse():
        return SuccessResponse(data: null);
      case ErrorResponse(error: final error):
        return ErrorResponse(error: error);
    }
  }

  @override
  Future<BaseResponse<void>> deletePhone() async {
    final response = await dataSource.deletePhone();
    switch (response) {
      case SuccessResponse():
        return SuccessResponse(data: null);
      case ErrorResponse(error: final error):
        return ErrorResponse(error: error);
    }
  }

  @override
  Future<BaseResponse<void>> deletePicture() async {
    final response = await dataSource.deletePicture();
    switch (response) {
      case SuccessResponse():
        return SuccessResponse(data: null);
      case ErrorResponse(error: final error):
        return ErrorResponse(error: error);
    }
  }

  @override
  Future<BaseResponse<void>> deleteCover() async {
    final response = await dataSource.deleteCover();
    switch (response) {
      case SuccessResponse():
        return SuccessResponse(data: null);
      case ErrorResponse(error: final error):
        return ErrorResponse(error: error);
    }
  }
}
