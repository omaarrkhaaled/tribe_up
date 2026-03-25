import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/profile/domain/repositories/profile_repositoriy.dart';

@lazySingleton
class UpdateBioUseCase {
  final ProfileRepositoriy repositoriy;

  UpdateBioUseCase(this.repositoriy);
  Future<BaseResponse<void>> call(String? bio) async {
    return await repositoriy.updateBio(bio);
  }
}
