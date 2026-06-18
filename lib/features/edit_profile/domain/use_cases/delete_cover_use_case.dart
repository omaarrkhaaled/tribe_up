import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/edit_profile/domain/repositories/edit_profile_repository.dart';

@lazySingleton
class DeleteCoverUseCase {
  final EditProfileRepository repositoriy;

  DeleteCoverUseCase(this.repositoriy);
  Future<BaseResponse<void>> call() async {
    return await repositoriy.deleteCover();
  }
}
