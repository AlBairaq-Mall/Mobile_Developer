import 'package:dio/dio.dart';
import 'package:go_router/go_router.dart';

import '../../../app/router/app_navigator.dart';
import '../../../app/router/app_routes.dart';
import '../../services/secure_storage_service.dart';

/// Injects Laravel Sanctum Bearer token on every request.
/// Clears session and redirects to login on 401.
class AuthInterceptor extends Interceptor {
  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await SecureStorageService.instance.readToken();
    if (token != null && token.isNotEmpty) {
      options.headers['Authorization'] = 'Bearer $token';
    }
    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      await SecureStorageService.instance.clearAll();
      final context = rootNavigatorKey.currentContext;
      if (context != null && context.mounted) {
        final location = GoRouter.of(context).state.uri.toString();
        final redirect = Uri.encodeComponent(location);
        context.go('${AppRoutes.login}?redirect=$redirect');
      }
    }
    handler.next(err);
  }
}
