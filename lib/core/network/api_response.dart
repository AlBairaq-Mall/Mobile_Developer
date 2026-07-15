import '../utils/json_parser.dart';

/// Standard Laravel envelope:
/// `{ "success": true, "message": "...", "data": ... }`
class ApiResponse<T> {
  final bool success;
  final String message;
  final T? data;
  final int? statusCode;

  const ApiResponse({
    required this.success,
    required this.message,
    this.data,
    this.statusCode,
  });

  bool get isSuccess => success;
  bool get isFailure => !success;
  bool get isUnauthorized => statusCode == 401;
  bool get isNotFound => statusCode == 404;
  bool get isValidationError => statusCode == 422;
  bool get isServerError => (statusCode ?? 0) >= 500;

  factory ApiResponse.success(
    T data, {
    String message = '',
    int? statusCode,
  }) =>
      ApiResponse(
        success: true,
        message: message,
        data: data,
        statusCode: statusCode,
      );

  factory ApiResponse.failure(
    String message, {
    int? statusCode,
  }) =>
      ApiResponse(
        success: false,
        message: message,
        statusCode: statusCode,
      );

  factory ApiResponse.fromEnvelope(
    dynamic raw, {
    required T Function(dynamic json) parser,
    int? statusCode,
  }) {
    final map = JsonParser.map(raw);
    final success = JsonParser.boolValue(map['success']);
    final message = JsonParser.string(map['message']);
    final payload = map['data'];

    if (!success) {
      return ApiResponse.failure(message, statusCode: statusCode);
    }

    try {
      return ApiResponse.success(parser(payload), message: message, statusCode: statusCode);
    } catch (_) {
      return ApiResponse.failure('فشل تحليل البيانات', statusCode: statusCode);
    }
  }

  R fold<R>({
    required R Function(T data) onSuccess,
    required R Function(String error) onError,
  }) {
    if (isSuccess && data != null) return onSuccess(data as T);
    return onError(message.isNotEmpty ? message : 'حدث خطأ غير متوقع');
  }
}
