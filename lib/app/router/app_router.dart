import 'package:bhm_supermarket/features/admin/presentation/admin_coupons_screen.dart';
import 'package:bhm_supermarket/features/orders/models/order_model.dart';
import 'package:go_router/go_router.dart';
import '../../features/orders/presentation/order_details_screen.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/address/presentation/address_management_screen.dart';
import '../../features/admin/presentation/admin_login_screen.dart';
import '../../features/admin/presentation/admin_dashboard_screen.dart';
import '../../features/admin/presentation/admin_orders_screen.dart';
import '../../features/admin/presentation/admin_products_screen.dart';
import '../../features/admin/presentation/admin_users_screen.dart';
import '../../features/admin/presentation/admin_delivery_screen.dart';
import '../../features/admin/presentation/admin_reports_screen.dart';
import '../../features/admin/presentation/admin_settings_screen.dart';
import '../../features/admin/presentation/admin_offers_screen.dart';
import '../../features/auth/presentation/login_screen.dart';
import '../../features/auth/presentation/register_screen.dart';
import '../../features/products/presentation/category_products_screen.dart';
import '../../features/checkout/presentation/checkout_screen.dart';
import '../../features/delivery/presentation/delivery_main_screen.dart';
import '../../features/delivery/presentation/delivery_earnings_screen.dart';
import '../../features/info/presentation/static_info_screen.dart';
import '../../features/navigation/presentation/main_navigation_screen.dart';
import '../../features/notifications/presentation/notifications_screen.dart';
import '../../features/onboarding/presentation/onboarding_screen.dart';
import '../../features/orders/presentation/order_success_screen.dart';
import '../../features/orders/presentation/order_tracking_screen.dart';
import '../../features/orders/presentation/orders_screen.dart';
import '../../features/search/presentation/search_screen.dart';
import '../../features/settings/presentation/settings_screen.dart';
import '../../features/splash/presentation/splash_screen.dart';
import 'route_guards.dart';
import 'app_routes.dart';

import 'app_navigator.dart' show rootNavigatorKey;

class AppRouter {
  AppRouter._();

  static GoRouter create(AuthProvider authProvider) => GoRouter(
    navigatorKey: rootNavigatorKey,
    debugLogDiagnostics: true,
    initialLocation: AppRoutes.splash,
    refreshListenable: authProvider,
    redirect: (context, state) {
      return RouteGuards.redirect(authProvider, state.matchedLocation);
    },
    routes: [
      GoRoute(path: AppRoutes.splash, builder: (_, __) => const SplashScreen()),
      GoRoute(
        path: AppRoutes.onboarding,
        builder: (_, __) => const OnboardingScreen(),
      ),
      GoRoute(
        path: AppRoutes.login,
        builder: (_, state) =>
            LoginScreen(redirectTo: state.uri.queryParameters['redirect']),
      ),
      GoRoute(
        path: AppRoutes.register,
        builder: (_, __) => const RegisterScreen(),
      ),
      GoRoute(
        path: AppRoutes.home,
        builder: (_, state) {
          final tabStr = state.uri.queryParameters['tab'];
          return MainNavigationScreen(
            initialTab: tabStr != null ? int.tryParse(tabStr) : null,
          );
        },
      ),
      GoRoute(path: AppRoutes.search, builder: (_, __) => const SearchScreen()),
      GoRoute(
        path: '${AppRoutes.categories}/:categoryId',
        builder: (_, state) => CategoryProductsScreen(
          categoryId: state.pathParameters['categoryId']!,
          categoryName: state.uri.queryParameters['name'],
        ),
      ),
      GoRoute(path: AppRoutes.orders, builder: (_, __) => const OrdersScreen()),
      GoRoute(
        path: AppRoutes.checkout,
        builder: (_, __) => const CheckoutScreen(),
      ),
      GoRoute(
        path: AppRoutes.notifications,
        builder: (_, __) => const NotificationsScreen(),
      ),
      GoRoute(
        path: AppRoutes.addresses,
        builder: (context, state) {
          final fromCheckout = state.extra == true;

          return AddressManagementScreen(fromCheckout: fromCheckout);
        },
      ),
      GoRoute(
        path: AppRoutes.settings,
        builder: (_, __) => const SettingsScreen(),
      ),
      GoRoute(
        path: AppRoutes.orderSuccess,
        builder: (_, state) =>
            OrderSuccessScreen(orderNumber: (state.extra as String?) ?? '0000'),
      ),
      GoRoute(
        path: AppRoutes.orderTracking,
        builder: (_, state) => OrderTrackingScreen(
          orderNumber: state.pathParameters['orderNumber'] ?? '0000',
        ),
      ),
      GoRoute(
        path: AppRoutes.aboutUs,
        builder: (_, __) => const StaticInfoScreen(
          title: 'من نحن',
          content:
              'بيرق مول هو سوبر ماركت إلكتروني يوفر جميع احتياجاتكم من المنتجات الغذائية ومستلزمات المنزل، مع خدمة توصيل سريعة وموثوقة لجميع المناطق.',
        ),
      ),
      GoRoute(
        path: AppRoutes.contactUs,
        builder: (_, __) => StaticInfoScreen.contactUs(),
      ),
      GoRoute(
        path: AppRoutes.faq,
        builder: (_, __) => const StaticInfoScreen(
          title: 'الأسئلة الشائعة',
          content: 'سيتم إضافة الأسئلة الشائعة قريباً.',
        ),
      ),
      GoRoute(
        path: AppRoutes.privacyPolicy,
        builder: (_, __) => const StaticInfoScreen(
          title: 'سياسة الخصوصية',
          content: 'سيتم إضافة سياسة الخصوصية قريباً.',
        ),
      ),
      GoRoute(
        path: AppRoutes.termsOfUse,
        builder: (_, __) => const StaticInfoScreen(
          title: 'شروط الاستخدام',
          content: 'سيتم إضافة شروط الاستخدام قريباً.',
        ),
      ),
      GoRoute(
        path: AppRoutes.adminLogin,
        builder: (_, __) => const AdminLoginScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminDashboard,
        builder: (_, __) => const AdminDashboardScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminOrders,
        builder: (_, __) => const AdminOrdersScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminProducts,
        builder: (_, __) => const AdminProductsScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminUsers,
        builder: (_, __) => const AdminUsersScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminDelivery,
        builder: (_, __) => const AdminDeliveryScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminReports,
        builder: (_, __) => const AdminReportsScreen(),
      ),
      GoRoute(
        path: AppRoutes.adminSettings,
        builder: (_, __) => const AdminSettingsScreen(),
      ),
      // GoRoute(
      //   path: AppRoutes.adminAds,
      //   builder: (_, __) => const AdminAdsScreen(),
      // ),
      GoRoute(
        path: AppRoutes.adminOffers,
        builder: (_, __) => const AdminOffersScreen(),
      ),
      GoRoute(
        path: AppRoutes.deliveryEarnings,
        builder: (_, __) => const DeliveryEarningsScreen(),
      ),
      // GoRoute(
      //   path: AppRoutes.deliveryLogin,
      //   builder: (_, __) => const DeliveryLoginScreen(),
      // ),
      GoRoute(
        path: AppRoutes.deliveryHome,
        builder: (_, __) => const DeliveryMainScreen(),
      ),
      GoRoute(
        path: AppRoutes.orderDetails,
        builder: (_, state) {
          return OrderDetailsScreen(order: state.extra as OrderModel);
        },
      ),
      GoRoute(
        path: AppRoutes.adminCoupons,
        builder: (context, state) => const AdminCouponsScreen(),
      ),
    ],
  );
}
