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

    final language = await SecureStorageService.instance.readLanguage();

    options.headers['Accept-Language'] = language;

    handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    if (err.response?.statusCode == 401) {
      // Skip redirect for the logout endpoint itself — it may return 401
      // if the token is already expired, and we don't want a redirect loop.
      final path = err.requestOptions.path;
      final isLogoutRequest = path.contains(AppRoutes.login.replaceAll('/', '')) == false &&
          (path == '/logout' || path.endsWith('/logout'));

      if (!isLogoutRequest) {
        // Clear local credentials immediately so the UI reflects the logged-out state.
        await SecureStorageService.instance.clearAll();

        final context = rootNavigatorKey.currentContext;

        if (context != null && context.mounted) {
          final location = GoRouter.of(context).state.uri.toString();

          context.go(
            '${AppRoutes.login}?redirect=${Uri.encodeComponent(location)}',
          );
        }
      }
    }
    handler.next(err);
  }
}
