import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/edit_profile/domain/repositories/edit_profile_repository.dart';

@lazySingleton
class UpdateCoverUseCase {
  final EditProfileRepository repositoriy;

  UpdateCoverUseCase(this.repositoriy);
  Future<BaseResponse<void>> call(File? cover) async {
    return await repositoriy.updateCover(cover);
  }
}
