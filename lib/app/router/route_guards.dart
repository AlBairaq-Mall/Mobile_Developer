import '../../features/auth/models/user_model.dart';
import '../../features/auth/providers/auth_provider.dart';
import 'app_routes.dart';

class RouteGuards {
  RouteGuards._();

  static String? redirect(AuthProvider auth, String location) {
    // انتظر انتهاء استرجاع الجلسة
    if (!auth.initialized) {
      return location == AppRoutes.splash ? null : AppRoutes.splash;
    }

    final loggedIn = auth.isLoggedIn;

    const protectedRoutes = {
      AppRoutes.checkout,
      AppRoutes.orders,
      AppRoutes.profile,
      AppRoutes.addresses,
      AppRoutes.notifications,
    };

    // ===== Guest =====

    if (!loggedIn) {
      if (protectedRoutes.contains(location)) {
        auth.setPendingRedirect(location);
        return AppRoutes.login;
      }

      if (location.startsWith('/admin')) {
        return AppRoutes.adminLogin;
      }

      if (location.startsWith('/delivery')) {
        return AppRoutes.login;
      }

      return null;
    }

    final role = auth.user!.role;

    // ===== Login/Register =====

    if (location == AppRoutes.login ||
        location == AppRoutes.register ||
        location == AppRoutes.adminLogin ||
        location == AppRoutes.deliveryLogin) {
      switch (role) {
        case UserRole.customer:
          return auth.consumePendingRedirect();

        case UserRole.admin:
          return AppRoutes.adminDashboard;

        case UserRole.delivery:
          return AppRoutes.deliveryHome;
      }
    }

    // ===== حماية صفحات الإدارة =====

    if (location.startsWith('/admin')) {
      if (role != UserRole.admin) {
        return AppRoutes.home;
      }
    }

    // ===== حماية صفحات المندوب =====

    if (location.startsWith('/delivery')) {
      if (role != UserRole.delivery) {
        return AppRoutes.home;
      }
    }

    return null;
  }
}
