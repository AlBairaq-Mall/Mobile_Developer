import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:pretty_dio_logger/pretty_dio_logger.dart';

import '../config/api_config.dart';
import 'interceptors/auth_interceptor.dart';

/// Unified HTTP client for Laravel.
///
/// Use [instance] for the default single-branch setup.
/// Use [forBaseUrl] when multi-branch / multi-tenant is enabled later.
class ApiClient {
  ApiClient._(this._dio);

  static final ApiClient instance = ApiClient._(_createDio(ApiConfig.baseUrl));

  final Dio _dio;
  Dio get dio => _dio;

  factory ApiClient.forBaseUrl(String baseUrl) =>
      ApiClient._(_createDio(baseUrl));

  static Dio _createDio(String baseUrl) {
    final dio = Dio(
      BaseOptions(
        baseUrl: baseUrl,
        connectTimeout: ApiConfig.connectTimeout,
        receiveTimeout: ApiConfig.receiveTimeout,
        sendTimeout: ApiConfig.sendTimeout,
        headers: ApiConfig.defaultHeaders,
      ),
    );

    dio.interceptors.add(AuthInterceptor());

    if (kDebugMode) {
      dio.interceptors.add(
        PrettyDioLogger(
          requestHeader: true,
          requestBody: true,
          responseHeader: false,
          responseBody: true,
          error: true,
        ),
      );
    }

    return dio;
  }
}
