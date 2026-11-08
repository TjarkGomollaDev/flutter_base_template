import 'package:dio/dio.dart';

enum ApiErrorType { timeout, badResponse, noInternet, unknown }

class ApiException implements Exception {
  final String message;
  final int? statusCode;
  final ApiErrorType type;

  ApiException({required this.message, required this.type, this.statusCode});

  factory ApiException.fromDioException(DioException error) {
    switch (error.type) {
      case DioExceptionType.connectionTimeout:
      case DioExceptionType.receiveTimeout:
      case DioExceptionType.sendTimeout:
        return ApiException(
          message: 'Connection to server timed out.',
          type: ApiErrorType.timeout,
        );
      case DioExceptionType.badResponse:
        final statusCode = error.response?.statusCode;
        return ApiException(
          message:
              'Server error: $statusCode. ${error.response?.statusMessage}',
          statusCode: statusCode,
          type: ApiErrorType.badResponse,
        );
      case DioExceptionType.connectionError:
        return ApiException(
          message: 'No internet connection.',
          type: ApiErrorType.noInternet,
        );
      default:
        return ApiException(
          message: 'Unexpected network error.',
          type: ApiErrorType.unknown,
        );
    }
  }

  @override
  String toString() => message;
}
