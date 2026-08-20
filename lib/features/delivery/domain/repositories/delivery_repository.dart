import '../../../../core/network/api_response.dart';
import '../../models/delivery_order_model.dart';

abstract class DeliveryRepository {
  Future<ApiResponse<List<DeliveryOrderModel>>> getAvailableOrders();
  Future<ApiResponse<List<DeliveryOrderModel>>> getOrders();

  Future<ApiResponse<DeliveryOrderModel>> getOrderById(String id);
  Future<ApiResponse<DeliveryOrderModel>> claimOrder(String id);

  Future<ApiResponse<void>> updateOrderStatus({
    required String orderId,
    required String status,
    String? paymentStatus,
  });

  Future<ApiResponse<void>> assignDriver({
    required String orderId,
    required int deliveryDriverId,
  });
}
