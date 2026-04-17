import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/profile/domain/repositories/edit_profile_repository.dart';

@lazySingleton
class UpdatePictureUseCase {
  final EditProfileRepository repositoriy;

  UpdatePictureUseCase(this.repositoriy);
  Future<BaseResponse<void>> call(File? picture) async {
    return await repositoriy.updatePicture(picture);
  }
}
