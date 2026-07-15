import '../../../../core/network/api_response.dart';
import '../../models/order_model.dart';

abstract class OrderRepository {
  Future<ApiResponse<List<OrderModel>>> getMyOrders();

  Future<ApiResponse<Map<String, dynamic>>> createOrder({
    required String addressId,
    required String paymentMethod,
    required List<Map<String, dynamic>> items,
    String? couponCode,
  });

  Future<ApiResponse<Map<String, dynamic>>> trackOrder(String orderNumber);
}
