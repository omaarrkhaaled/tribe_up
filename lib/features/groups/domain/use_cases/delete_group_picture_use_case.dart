import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/groups/domain/repositories/groups_repository.dart';

@lazySingleton
class DeleteGroupPictureUseCase {
  final GroupsRepository repository;

  DeleteGroupPictureUseCase(this.repository);

  Future<BaseResponse<void>> call(int id) async {
    return await repository.deleteGroupPicture(id);
  }
}
