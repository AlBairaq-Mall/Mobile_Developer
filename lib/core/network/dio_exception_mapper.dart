import 'package:dio/dio.dart';

import 'api_response.dart';
import 'app_exception.dart';

AppException mapDioException(DioException error) {
  switch (error.type) {
    case DioExceptionType.connectionTimeout:
    case DioExceptionType.sendTimeout:
    case DioExceptionType.receiveTimeout:
      return const TimeoutException();
    case DioExceptionType.connectionError:
      return const NetworkException();
    default:
      break;
  }

  final status = error.response?.statusCode;
  final body = error.response?.data;
  final message = _extractMessage(body) ?? error.message ?? 'حدث خطأ غير متوقع';

  switch (status) {
    case 400:
      return ValidationException(message);
    case 401:
      return const UnauthorizedException();
    case 403:
      return ValidationException(message);
    case 404:
      return const NotFoundException();
    case 422:
      return ValidationException(message);
    default:
      if (status != null && status >= 500) {
        return ServerException(message);
      }
      return ServerException(message);
  }
}

ApiResponse<T> apiResponseFromDioError<T>(DioException error) {
  final exception = mapDioException(error);
  return ApiResponse.failure(
    exception.message,
    statusCode: error.response?.statusCode,
  );
}

String? _extractMessage(dynamic body) {
  if (body is Map) {
    final map = Map<String, dynamic>.from(body);
    if (map['message'] != null) return map['message'].toString();
    final errors = map['errors'];
    if (errors is Map) {
      for (final entry in errors.entries) {
        final value = entry.value;
        if (value is List && value.isNotEmpty) return value.first.toString();
        if (value != null) return value.toString();
      }
    }
  }
  return null;
}
