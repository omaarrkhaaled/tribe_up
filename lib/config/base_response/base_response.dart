import 'package:tribe_up/core/errors/exception.dart';

sealed class BaseResponse<T> {}

class SuccessResponse<T> extends BaseResponse<T> {
  final T data;
  SuccessResponse({required this.data});
}

class ErrorResponse<T> extends BaseResponse<T> {
  final AppException error;
  ErrorResponse({required this.error});
}
