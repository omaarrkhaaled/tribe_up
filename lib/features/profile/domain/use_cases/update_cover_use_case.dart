import 'dart:io';
import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/profile/domain/repositories/profile_repositoriy.dart';

@lazySingleton
class UpdateCoverUseCase {
  final ProfileRepositoriy repositoriy;

  UpdateCoverUseCase(this.repositoriy);
  Future<BaseResponse<void>> call(File? cover) async {
    return await repositoriy.updateCover(cover);
  }
}
