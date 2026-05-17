import 'dart:io';

import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/groups/data/models/response/groups_response.dart';
import 'package:tribe_up/features/groups/domain/repositories/groups_repository.dart';

@lazySingleton
class CreateGroupUseCase {
  final GroupsRepository repository;

  CreateGroupUseCase(this.repository);

  Future<BaseResponse<Group>> call({
    required String groupName,
    required String description,
    required String accessibility,
    File? profilePicture,
  }) async {
    return await repository.createGroup(
      groupName,
      description,
      accessibility,
      profilePicture,
    );
  }
}
