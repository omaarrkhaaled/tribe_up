import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/groups/domain/repositories/groups_repository.dart';

@lazySingleton
class UpdateGroupPictureUseCase {
  final GroupsRepository repository;

  UpdateGroupPictureUseCase(this.repository);

  Future<BaseResponse<void>> call({required int id, required File file}) async {
    return await repository.updateGroupPicture(id, file);
  }
}
