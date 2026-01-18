import 'package:dio/dio.dart';

abstract class AppException implements Exception {
  final String message;

  const AppException({required this.message});
}

class RemoteException extends AppException {
  const RemoteException({required super.message});

  factory RemoteException.fromDioError(Exception e) {
    if (e is DioException) {
      switch (e.type) {
        case DioExceptionType.connectionTimeout:
          return const RemoteException(message: 'Connection timeout');
        case DioExceptionType.receiveTimeout:
          return const RemoteException(message: 'Receive timeout');
        case DioExceptionType.badResponse:
          return RemoteException(
            message: 'Bad response: ${e.response?.statusCode} ${e.response?.data['message']}',
          );
        case DioExceptionType.connectionError:
          return RemoteException(message: 'Connection error: ${e.message}');
        case DioExceptionType.cancel:
          return const RemoteException(message: 'Request was canceled');
        case DioExceptionType.unknown:
          return RemoteException(message: 'Unexpected error: ${e.message}');
        case DioExceptionType.sendTimeout:
          return const RemoteException(message: 'Send timeout');
        case DioExceptionType.badCertificate:
          return const RemoteException(message: 'Bad certificate');
      }
    } else {
      return RemoteException(message: 'Unexpected error: ${e.toString()}');
    }
  }
}

class LocalException extends AppException {
  const LocalException({required super.message});
}
