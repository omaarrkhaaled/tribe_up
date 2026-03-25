import 'package:injectable/injectable.dart';
import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/features/profile/data/models/request/update_name_request.dart';
import 'package:tribe_up/features/profile/domain/repositories/profile_repositoriy.dart';

@lazySingleton
class UpdateNameUseCase {
  final ProfileRepositoriy repositoriy;

  UpdateNameUseCase(this.repositoriy);
  Future<BaseResponse<void>> call(UpdateNameRequest request) async {
    return await repositoriy.updateName(request);
  }
}
