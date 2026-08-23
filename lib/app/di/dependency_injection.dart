import 'package:bhm_supermarket/features/cart/data/datasource/cart_remote_datasource.dart';

import '../../core/api/api_client.dart';
import '../../core/services/secure_storage_service.dart';
import '../../features/address/data/datasources/address_remote_datasource.dart';
import '../../features/address/data/repositories/address_repository_impl.dart';
import '../../features/address/domain/repositories/address_repository.dart';
import '../../features/auth/data/datasources/auth_remote_datasource.dart';
import '../../features/auth/data/repositories/auth_repository_impl.dart';
import '../../features/auth/domain/repositories/auth_repository.dart';
import '../../features/categories/data/datasources/category_remote_datasource.dart';
import '../../features/categories/data/repositories/category_repository_impl.dart';
import '../../features/categories/domain/repositories/category_repository.dart';
import '../../features/orders/data/datasources/order_remote_datasource.dart';
import '../../features/orders/data/repositories/order_repository_impl.dart';
import '../../features/orders/domain/repositories/order_repository.dart';
import '../../features/products/data/datasources/product_remote_datasource.dart';
import '../../features/products/data/repositories/product_repository_impl.dart';
import '../../features/products/domain/repositories/product_repository.dart';
import '../../features/cart/data/repositories/cart_repository_impl.dart';
import '../../features/cart/domain/repositories/cart_repository.dart';
import '../../features/favorites/data/datasources/favorites_remote_datasource.dart';
import '../../features/favorites/data/repositories/favorites_repository_impl.dart';
import '../../features/favorites/domain/repositories/favorites_repository.dart';
import '../../features/ads/data/datasources/ads_remote_datasource.dart';
import '../../features/ads/data/repositories/ads_repository_impl.dart';
import '../../features/ads/domain/repositories/ads_repository.dart';
import '../../features/ads/data/datasources/offers_remote_datasource.dart';
import '../../features/ads/data/repositories/offers_repository_impl.dart';
import '../../features/ads/domain/repositories/offers_repository.dart';
import '../../features/delivery/data/datasources/delivery_remote_datasource.dart';
import '../../features/delivery/data/repositories/delivery_repository_impl.dart';
import '../../features/delivery/domain/repositories/delivery_repository.dart';
import '../../features/coupons/data/datasources/coupon_remote_datasource.dart';
import '../../features/coupons/data/repositories/coupon_repository_impl.dart';
import '../../features/coupons/domain/repositories/coupon_repository.dart';
import '../../features/admin/data/datasources/admin_reports_remote_datasource.dart';
import '../../features/admin/data/repositories/admin_reports_repository_impl.dart';
import '../../features/admin/domain/repositories/admin_reports_repository.dart';

/// Central dependency wiring — swap implementations here without touching UI.
class DependencyInjection {
  DependencyInjection._();

  static final dio = ApiClient.instance.dio;

  static final AuthRepository authRepository = AuthRepositoryImpl(
    AuthRemoteDataSource(dio),
    SecureStorageService.instance,
  );

  static final ProductRepository productRepository = ProductRepositoryImpl(
    ProductRemoteDataSource(dio),
  );
  static final AdsRepository adsRepository = AdsRepositoryImpl(
    AdsRemoteDataSource(dio),
  );
  static final OffersRepository offersRepository = OffersRepositoryImpl(
    OffersRemoteDataSource(dio),
  );
  static final CartRepository cartRepository = CartRepositoryImpl(
    CartRemoteDataSource(dio),
  );
  static final FavoritesRepository favoritesRepository =
      FavoritesRepositoryImpl(FavoritesRemoteDataSource(dio));

  static final CategoryRepository categoryRepository = CategoryRepositoryImpl(
    CategoryRemoteDataSource(dio),
  );

  static final OrderRepository orderRepository = OrderRepositoryImpl(
    OrderRemoteDataSource(dio),
  );
  static final AddressRepository addressRepository = AddressRepositoryImpl(
    AddressRemoteDataSource(dio),
  );
  static final DeliveryRepository deliveryRepository = DeliveryRepositoryImpl(
    DeliveryRemoteDataSource(dio),
  );
  static final CouponRepository couponRepository = CouponRepositoryImpl(
    CouponRemoteDataSource(dio),
  );
  static final AdminReportsRepository adminReportsRepository =
      AdminReportsRepositoryImpl(
    AdminReportsRemoteDataSource(dio),
  );
}
