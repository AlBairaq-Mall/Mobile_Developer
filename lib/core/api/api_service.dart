import 'package:dio/dio.dart';

/// خدمة API مركزية للتواصل مع Laravel Backend.
/// جميع endpoints موثقة هنا مع بنية البيانات المتوقعة.
///
/// الاستخدام:
///   final api = ApiService.instance;
///   final products = await api.getProducts();
///
/// للربط بـ Laravel:
///   1. غيّر [baseUrl] لرابط الـ API الفعلي
///   2. عند تسجيل الدخول، احفظ الـ token في SecureStorage
///   3. الـ AuthInterceptor يضيف الـ token تلقائياً لكل طلب
class ApiService {
  ApiService._();
  static final ApiService instance = ApiService._();

  // ══════════════════════════════════════════════
  // الإعداد الأساسي
  // ══════════════════════════════════════════════

  /// رابط API الخاص بـ Laravel - غيّره قبل النشر
  static const String baseUrl = 'https://backend-albarqy.onrender.com/api';

  // ignore: unused_field
  late final Dio _dio = Dio(BaseOptions(
    baseUrl: baseUrl,
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 30),
    headers: {
      'Accept': 'application/json',
      'Content-Type': 'application/json',
    },
  ))
    ..interceptors.add(_AuthInterceptor())
    ..interceptors.add(_LogInterceptor());

  // ══════════════════════════════════════════════
  // المصادقة - Auth
  // ══════════════════════════════════════════════

  /// إرسال OTP - POST /api/auth/send-otp
  /// Body: { "contact": "phone/email", "method": "phone|email" }
  // Future<void> sendOtp(
  //     {required String contact, required String method}) async {
  //   // await _dio.post('/auth/send-otp', data: {'contact': contact, 'method': method});
  //   throw UnimplementedError('اربط مع Laravel');
  // }

  /// التحقق من OTP - POST /api/auth/verify-otp
  /// Body: { "contact": "...", "otp": "1234", "method": "phone|email" }
  /// Returns: { "token": "...", "user": {...} }
  // Future<Map<String, dynamic>> verifyOtp({
  //   required String contact,
  //   required String otp,
  //   required String method,
  // }) async {
  //   // final res = await _dio.post('/auth/verify-otp', data: {...});
  //   // return res.data;
  //   throw UnimplementedError('اربط مع Laravel');
  // }

  /// تسجيل مستخدم جديد - POST /api/auth/register
  /// Body: { "name": "...", "phone": "...", "email": "..." }
  Future<Map<String, dynamic>> register({
    required String name,
    required String phone,
    String? email,
  }) async {
    throw UnimplementedError('اربط مع Laravel');
  }

  /// تسجيل خروج - POST /api/auth/logout
  Future<void> logout() async {
    throw UnimplementedError('اربط مع Laravel');
  }

  // ══════════════════════════════════════════════
  // المنتجات - Products
  // ══════════════════════════════════════════════

  /// جلب كل المنتجات - GET /api/products
  /// Query: ?category_id=&search=&page=
  /// Returns: { data: [...], meta: {total, per_page, current_page} }
  Future<List<Map<String, dynamic>>> getProducts({
    String? categoryId,
    String? search,
    int page = 1,
  }) async {
    throw UnimplementedError('اربط مع Laravel');
  }

  /// جلب منتج بالـ ID - GET /api/products/{id}
  Future<Map<String, dynamic>> getProduct(String id) async {
    throw UnimplementedError('اربط مع Laravel');
  }

  /// جلب وحدات الصنف بالـ ItemCode (SKU) - GET /api/products/{itemCode}/units
  /// Returns: [{ id, unit_name, package, price, old_price, is_default, description }]
  Future<List<Map<String, dynamic>>> getProductUnits(String itemCode) async {
    throw UnimplementedError('اربط مع Laravel');
  }

  // ══════════════════════════════════════════════
  // الأقسام - Categories
  // ══════════════════════════════════════════════

  /// GET /api/categories
  Future<List<Map<String, dynamic>>> getCategories() async {
    throw UnimplementedError('اربط مع Laravel');
  }

  // ══════════════════════════════════════════════
  // الطلبات - Orders
  // ══════════════════════════════════════════════

  /// إنشاء طلب جديد - POST /api/orders
  /// Body: { address_id, payment_method, coupon_code, items: [{product_id, unit, qty, price}] }
  /// Returns: { order_number, total, status }
  Future<Map<String, dynamic>> createOrder({
    required String addressId,
    required String paymentMethod,
    required List<Map<String, dynamic>> items,
    String? couponCode,
  }) async {
    throw UnimplementedError('اربط مع Laravel');
  }

  /// جلب طلبات المستخدم - GET /api/orders
  Future<List<Map<String, dynamic>>> getMyOrders() async {
    throw UnimplementedError('اربط مع Laravel');
  }

  /// تتبع طلب - GET /api/orders/{orderNumber}/track
  Future<Map<String, dynamic>> trackOrder(String orderNumber) async {
    throw UnimplementedError('اربط مع Laravel');
  }

  // ══════════════════════════════════════════════
  // العناوين - Addresses
  // ══════════════════════════════════════════════

  /// GET /api/addresses
  Future<List<Map<String, dynamic>>> getAddresses() async {
    throw UnimplementedError('اربط مع Laravel');
  }

  /// POST /api/addresses
  Future<Map<String, dynamic>> addAddress(Map<String, dynamic> data) async {
    throw UnimplementedError('اربط مع Laravel');
  }

  /// PUT /api/addresses/{id}
  Future<void> updateAddress(String id, Map<String, dynamic> data) async {
    throw UnimplementedError('اربط مع Laravel');
  }

  /// DELETE /api/addresses/{id}
  Future<void> deleteAddress(String id) async {
    throw UnimplementedError('اربط مع Laravel');
  }

  // ══════════════════════════════════════════════
  // المفضلة - Favorites
  // ══════════════════════════════════════════════

  /// GET /api/favorites
  Future<List<Map<String, dynamic>>> getFavorites() async {
    throw UnimplementedError('اربط مع Laravel');
  }

  /// POST /api/favorites/{productId}/toggle
  Future<bool> toggleFavorite(String productId) async {
    throw UnimplementedError('اربط مع Laravel');
  }

  // ══════════════════════════════════════════════
  // الإشعارات - Notifications
  // ══════════════════════════════════════════════

  /// GET /api/notifications
  Future<List<Map<String, dynamic>>> getNotifications() async {
    throw UnimplementedError('اربط مع Laravel');
  }

  // ══════════════════════════════════════════════
  // ADMIN - إدارة
  // ══════════════════════════════════════════════

  /// GET /api/admin/orders?status=&page=
  Future<List<Map<String, dynamic>>> adminGetOrders({String? status}) async {
    throw UnimplementedError('اربط مع Laravel');
  }

  /// PATCH /api/admin/orders/{id}/status
  /// Body: { "status": "preparing|out_for_delivery|delivered|cancelled" }
  Future<void> adminUpdateOrderStatus(String id, String status) async {
    throw UnimplementedError('اربط مع Laravel');
  }

  /// POST /api/admin/orders/{id}/assign-driver
  /// Body: { "driver_id": "..." }
  Future<void> adminAssignDriver(String orderId, String driverId) async {
    throw UnimplementedError('اربط مع Laravel');
  }

  /// POST /api/admin/products
  Future<Map<String, dynamic>> adminCreateProduct(
      Map<String, dynamic> data) async {
    throw UnimplementedError('اربط مع Laravel');
  }

  /// PUT /api/admin/products/{id}
  Future<void> adminUpdateProduct(String id, Map<String, dynamic> data) async {
    throw UnimplementedError('اربط مع Laravel');
  }

  /// GET /api/admin/users?role=
  Future<List<Map<String, dynamic>>> adminGetUsers({String? role}) async {
    throw UnimplementedError('اربط مع Laravel');
  }

  /// POST /api/admin/users (إضافة مدير أو سائق)
  /// Body: { "name", "email", "phone", "role": "admin|delivery|customer", "password" }
  Future<Map<String, dynamic>> adminCreateUser(
      Map<String, dynamic> data) async {
    throw UnimplementedError('اربط مع Laravel');
  }

  /// GET /api/admin/reports
  Future<Map<String, dynamic>> adminGetReports() async {
    throw UnimplementedError('اربط مع Laravel');
  }

  // ══════════════════════════════════════════════
  // DELIVERY - سائق التوصيل
  // ══════════════════════════════════════════════

  /// GET /api/delivery/current-orders
  Future<List<Map<String, dynamic>>> deliveryGetCurrentOrders() async {
    throw UnimplementedError('اربط مع Laravel');
  }

  /// PATCH /api/delivery/orders/{id}/start
  Future<void> deliveryStartOrder(String id) async {
    throw UnimplementedError('اربط مع Laravel');
  }

  /// PATCH /api/delivery/orders/{id}/complete
  Future<void> deliveryCompleteOrder(String id) async {
    throw UnimplementedError('اربط مع Laravel');
  }

  /// GET /api/delivery/history
  Future<List<Map<String, dynamic>>> deliveryGetHistory() async {
    throw UnimplementedError('اربط مع Laravel');
  }

  // ══════════════════════════════════════════════
  // Helper: رفع صورة
  // ══════════════════════════════════════════════

  /// POST /api/upload (رفع صور إيصالات الدفع أو المنتجات)
  Future<String> uploadImage(String filePath) async {
    throw UnimplementedError('اربط مع Laravel');
  }
}

// ══════════════════════════════════════════════════════
// Auth Interceptor - يضيف JWT Token لكل طلب
// ══════════════════════════════════════════════════════
class _AuthInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // TODO: اقرأ الـ token من SecureStorage
    // final token = await SecureStorage.read('token');
    // if (token != null) options.headers['Authorization'] = 'Bearer $token';
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    if (err.response?.statusCode == 401) {
      // TODO: انتقل لصفحة تسجيل الدخول عند انتهاء صلاحية التوكن
    }
    handler.next(err);
  }
}

// ══════════════════════════════════════════════════════
// Log Interceptor (development only)
// ══════════════════════════════════════════════════════
class _LogInterceptor extends Interceptor {
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    // ignore: avoid_print
    print('[API] \${options.method} \${options.uri}');
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    // ignore: avoid_print
    print('[API ERROR] \${err.response?.statusCode} \${err.message}');
    handler.next(err);
  }
}
