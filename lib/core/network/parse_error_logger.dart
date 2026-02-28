import 'package:dio/dio.dart';
import 'package:injectable/injectable.dart';
import 'package:retrofit/error_logger.dart';

/// Simple implementation of ParseErrorLogger for dependency injection
@LazySingleton(as: ParseErrorLogger)
class ParseErrorLoggerImpl implements ParseErrorLogger {
  @override
  void logError(
    Object error,
    StackTrace stackTrace,
    RequestOptions requestOptions,
  ) {
    // Simple error logging implementation
    // You can replace this with actual logging logic if needed
  }
}
