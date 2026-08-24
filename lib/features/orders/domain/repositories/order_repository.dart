import 'package:bhm_supermarket/core/network/api_response.dart';
import 'package:bhm_supermarket/features/orders/models/order_model.dart';

abstract class OrderRepository {
  Future<ApiResponse<List<OrderModel>>> getOrders();

  Future<ApiResponse<Map<String, dynamic>>> createOrder({
    required String locationId,
    required String paymentMethod,
    String? notes,
    String? couponCode,
    required List<Map<String, dynamic>> items,
  });
}
