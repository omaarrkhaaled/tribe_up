import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/profile/domain/repositories/profile_repositoriy.dart';

@lazySingleton
class DeleteCoverUseCase {
  final ProfileRepositoriy repositoriy;

  DeleteCoverUseCase(this.repositoriy);
  Future<BaseResponse<void>> call() async {
    return await repositoriy.deleteCover();
  }
}
