import 'package:tribe_up/config/base_response/base_response.dart';
import 'package:tribe_up/core/errors/exception.dart';

Future<BaseResponse<T>> safeApiCall<T>(Future<T> Function() apiCall) async {
  try {
    final response = await apiCall();
    return SuccessResponse<T>(data: response);
  } catch (error) {
    if (error is Exception) {
      return ErrorResponse<T>(error: RemoteException.fromDioError(error));
    }
    return ErrorResponse<T>(error: RemoteException(message: error.toString()));
  }
}
