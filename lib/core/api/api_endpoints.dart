/// Laravel REST endpoints (relative to [ApiConfig.baseUrl]).
class ApiEndpoints {
  ApiEndpoints._();

  static const authRegister = '/register';
  static const authLogin = '/login';
  static const authLogout = '/logout';
  static const me = '/me';
  static const refresh = '/refresh';

  // Catalog
  // categories
  static const categories = '/categories';
  // products
  static const products = '/products';
  static String product(String id) => '/products/$id';

  // Orders
  static const orders = '/orders';
  static String order(String id) => '/orders/$id';
  static String orderTrack(String orderNumber) => '/orders/$orderNumber/track';

// Users
  static const users = '/users';
  // Locations
  static const locations = '/locations';

  // Addresses
  static const addresses = '/addresses';
  static String address(String id) => '/addresses/$id';

  // Favorites
  static const favorites = '/favorites';
  static String favoriteToggle(String productId) =>
      '/favorites/$productId/toggle';

  static const myOrders = "/my-orders";

  // Profile
  // static const profile = '/profile';

  // Notifications
  static const notifications = '/notifications';

  // Admin
  static const adminOrders = '/admin/orders';
  static String adminOrderStatus(String id) => '/admin/orders/$id/status';
  static String adminAssignDriver(String orderId) =>
      '/admin/orders/$orderId/assign-driver';
  static const adminProducts = '/admin/products';
  static String adminProduct(String id) => '/admin/products/$id';
  static const adminUsers = '/admin/users';
  static const adminReports = '/admin/reports';

  // Delivery
  static const deliveryCurrentOrders = '/delivery/current-orders';
  static String deliveryStartOrder(String id) => '/delivery/orders/$id/start';
  static String deliveryCompleteOrder(String id) =>
      '/delivery/orders/$id/complete';
  static const deliveryHistory = '/delivery/history';

  // Upload
  static const upload = '/upload';
}
