import 'package:bhm_supermarket/core/network/api_response.dart';
import 'package:bhm_supermarket/features/orders/models/order_model.dart';

abstract class OrderRepository {
  Future<ApiResponse<List<OrderModel>>> getOrders();

  Future<ApiResponse<Map<String, dynamic>>> createOrder({
    required String addressId,
    required String paymentMethod,
    required double deliveryFee,
    required double discount,
    String? notes,
    String? couponCode,
    required List<Map<String, dynamic>> items,
  });
}
