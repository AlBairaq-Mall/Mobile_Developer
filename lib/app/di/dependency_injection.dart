import '../../core/api/api_client.dart';
import '../../core/services/secure_storage_service.dart';
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

  static final CategoryRepository categoryRepository = CategoryRepositoryImpl(
    CategoryRemoteDataSource(dio),
  );

  static final OrderRepository orderRepository = OrderRepositoryImpl(
    OrderRemoteDataSource(dio),
  );
}
