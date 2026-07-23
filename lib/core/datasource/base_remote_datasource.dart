import 'package:dio/dio.dart';

import '../network/api_response.dart';
import '../network/dio_exception_mapper.dart';
import '../utils/json_parser.dart';

/// Shared remote datasource helpers.
abstract class BaseRemoteDataSource {
  BaseRemoteDataSource(this.dio);

  final Dio dio;

  /// للـ APIs التي ترجع:
  /// {
  ///   "data": [...],
  ///   "links": {...},
  ///   "meta": {...}
  /// }
  Future<ApiResponse<T>> getPaginated<T>(
    String path, {
    Map<String, dynamic>? query,
    required T Function(dynamic json) parser,
  }) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: query,
      );

      return ApiResponse.success(
        parser(response.data['data']),
        statusCode: response.statusCode,
      );
    } on DioException catch (error) {
      return apiResponseFromDioError<T>(error);
    } catch (_) {
      return ApiResponse.failure('حدث خطأ غير متوقع');
    }
  }

  /// للـ APIs التي ترجع:
  /// {
  ///   "success": true,
  ///   "message": "...",
  ///   "data": ...
  /// }
  Future<ApiResponse<T>> getEnvelope<T>(
    String path, {
    Map<String, dynamic>? query,
    required T Function(dynamic json) parser,
  }) async {
    try {
      final response = await dio.get(
        path,
        queryParameters: query,
      );

      return ApiResponse.fromEnvelope(
        response.data,
        parser: parser,
        statusCode: response.statusCode,
      );
    } on DioException catch (error) {
      return apiResponseFromDioError<T>(error);
    } catch (_) {
      return ApiResponse.failure('حدث خطأ غير متوقع');
    }
  }

  Future<ApiResponse<T>> postEnvelope<T>(
    String path, {
    dynamic data,
    required T Function(dynamic json) parser,
  }) async {
    try {
      final response = await dio.post(path, data: data);

      return ApiResponse.fromEnvelope(
        response.data,
        parser: parser,
        statusCode: response.statusCode,
      );
    } on DioException catch (error) {
      return apiResponseFromDioError<T>(error);
    } catch (_) {
      return ApiResponse.failure('حدث خطأ غير متوقع');
    }
  }

  Future<ApiResponse<T>> putEnvelope<T>(
    String path, {
    dynamic data,
    required T Function(dynamic json) parser,
  }) async {
    try {
      final response = await dio.put(path, data: data);

      return ApiResponse.fromEnvelope(
        response.data,
        parser: parser,
        statusCode: response.statusCode,
      );
    } on DioException catch (error) {
      return apiResponseFromDioError<T>(error);
    } catch (_) {
      return ApiResponse.failure('حدث خطأ غير متوقع');
    }
  }

  Future<ApiResponse<void>> deleteEnvelope(
    String path, {
    dynamic data,
  }) async {
    try {
      final response = await dio.delete(path, data: data);

      final map = JsonParser.map(response.data);
      final success = JsonParser.boolValue(
        map['success'],
        fallback: true,
      );
      final message = JsonParser.string(map['message']);

      if (!success) {
        return ApiResponse.failure(
          message,
          statusCode: response.statusCode,
        );
      }

      return ApiResponse.success(
        null,
        message: message,
        statusCode: response.statusCode,
      );
    } on DioException catch (error) {
      return apiResponseFromDioError<void>(error);
    } catch (_) {
      return ApiResponse.failure('حدث خطأ غير متوقع');
    }
  }
}
