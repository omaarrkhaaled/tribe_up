import 'dart:io';
import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/error_logger.dart';
import 'package:retrofit/http.dart';
import 'package:tribe_up/core/constants/api_constants.dart';
import 'package:tribe_up/features/profile/data/models/request/update_name_request.dart';
import 'package:tribe_up/features/profile/data/models/response/profile_info_response.dart';
part 'edit_profile_api_client.g.dart';

@lazySingleton
@RestApi(baseUrl: ApiConstants.baseUrl)
abstract class EditProfileApiClient {
  @factoryMethod
  factory EditProfileApiClient(Dio dio) = _EditProfileApiClient;

  @GET(ApiConstants.profileInfoEndPoint)
  Future<ProfileInfoResponse> getProfileInfo();

  @PUT(ApiConstants.nameEndPoint)
  Future<void> updateName(@Body() UpdateNameRequest request);

  @PUT(ApiConstants.avatarEndPoint)
  Future<void> updateAvatar(@Body() String? avatar);

  @PUT(ApiConstants.bioEndPoint)
  Future<void> updateBio(@Body() String? bio);

  @PUT(ApiConstants.phoneEndPoint)
  Future<void> updatePhone(@Body() String? phone);

  @PUT(ApiConstants.pictureEndPoint)
  @MultiPart()
  Future<void> updatePicture(@Part(name: 'Picture') File? picture);

  @PUT(ApiConstants.coverEndPoint)
  @MultiPart()
  Future<void> updateCover(@Part(name: 'CoverPicture') File? cover);

  @DELETE(ApiConstants.deleteBioEndPoint)
  Future<void> deleteBio();

  @DELETE(ApiConstants.deletePhoneEndPoint)
  Future<void> deletePhone();

  @DELETE(ApiConstants.deletePictureEndPoint)
  Future<void> deletePicture();

  @DELETE(ApiConstants.deleteCoverEndPoint)
  Future<void> deleteCover();
}
