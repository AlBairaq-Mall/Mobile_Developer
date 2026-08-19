import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../di/dependency_injection.dart';
import '../theme/theme_provider.dart';
import '../localization/language_provider.dart';
import '../../features/address/providers/address_provider.dart';
import '../../features/auth/providers/auth_provider.dart';
import '../../features/cart/providers/cart_provider.dart';
import '../../features/categories/providers/category_provider.dart';
import '../../features/checkout/providers/checkout_provider.dart';
import '../../features/favorites/providers/favorites_provider.dart';
import '../../features/home/providers/home_provider.dart';
import '../../features/orders/providers/orders_provider.dart';
import '../../features/search/providers/search_provider.dart';
import '../../features/products/providers/product_provider.dart';
import '../../features/ads/providers/ads_provider.dart';
import '../../features/ads/providers/offers_provider.dart';
import '../../features/navigation/providers/navigation_provider.dart';
import '../../features/delivery/providers/delivery_provider.dart';
import '../../features/coupons/providers/coupon_provider.dart';

class AppProviders {
  AppProviders._();

  static List<SingleChildWidget> build(AuthProvider authProvider) => [
        ChangeNotifierProvider.value(value: authProvider),
        ChangeNotifierProvider(create: (_) => ThemeProvider()),
        ChangeNotifierProvider(create: (_) => LanguageProvider()),
        ChangeNotifierProvider(
          create: (_) => CartProvider(DependencyInjection.cartRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => FavoritesProvider(
            DependencyInjection.favoritesRepository,
            DependencyInjection.productRepository,
          ),
        ),
        ChangeNotifierProvider(
          create: (_) => SearchProvider(DependencyInjection.productRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => AddressProvider(DependencyInjection.addressRepository),
        ),
        ChangeNotifierProvider(create: (_) => CheckoutProvider()),
        ChangeNotifierProvider(
          create: (_) => HomeProvider(DependencyInjection.productRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => AdsProvider(DependencyInjection.adsRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => OffersProvider(DependencyInjection.offersRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => ProductProvider(DependencyInjection.productRepository),
        ),
        ChangeNotifierProvider(
          create: (_) =>
              CategoryProvider(DependencyInjection.categoryRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => OrdersProvider(DependencyInjection.orderRepository),
        ),
        ChangeNotifierProvider(create: (_) => NavigationProvider()),
        ChangeNotifierProvider(
          create: (_) =>
              DeliveryProvider(DependencyInjection.deliveryRepository),
        ),
        ChangeNotifierProvider(
          create: (_) => CouponProvider(DependencyInjection.couponRepository),
        ),
      ];
}
