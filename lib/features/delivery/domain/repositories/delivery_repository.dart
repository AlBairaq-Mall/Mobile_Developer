// import 'package:bhm_supermarket/features/delivery/models/delivery_order_model.dart';

// import '../../../../core/network/api_response.dart';

// abstract class DeliveryRepository {
//   /// GET /api/delivery/orders
//   Future<ApiResponse<List<DeliveryOrderModel>>> getOrders();

//   /// GET /api/delivery/orders/{id}
//   Future<ApiResponse<DeliveryOrderModel>> getOrderById(String id);

//   /// PATCH /api/delivery/orders/{id}/status
//   /// status: "delivered" | "cancelled"
//   /// paymentStatus: "pending" | "paid" | "failed"
//   Future<ApiResponse<void>> updateOrderStatus({
//     required String orderId,
//     required String status,
//     String? paymentStatus,
//   });

//   /// PATCH /api/orders/{id}/delivery-driver
//   /// Assigns a delivery driver to an order (admin action)
//   Future<ApiResponse<void>> assignDriver({
//     required String orderId,
//     required int deliveryDriverId,
//   });
// }

// import '../../../../core/network/api_response.dart';
// import '../../models/delivery_order_model.dart';

// abstract class DeliveryRepository {
//   /// GET /api/delivery/orders
//   Future<ApiResponse<List<DeliveryOrderModel>>> getOrders();

//   /// GET /api/delivery/orders/{id}
//   Future<ApiResponse<DeliveryOrderModel>> getOrderById(
//     String id,
//   );

//   /// PATCH /api/delivery/orders/{id}/status
//   ///
//   /// status:
//   /// delivered | cancelled
//   ///
//   /// paymentStatus:
//   /// pending | paid | failed
//   Future<ApiResponse<void>> updateOrderStatus({
//     required String orderId,
//     required String status,
//     String? paymentStatus,
//   });

//   /// PATCH /api/orders/{id}/delivery-driver
//   Future<ApiResponse<void>> assignDriver({
//     required String orderId,
//     required int deliveryDriverId,
//   });

//   /// PATCH /api/delivery/orders/{id}/status
//   Future<ApiResponse<void>> markOrderShipped({
//   required String orderId,
// });
// }

import '../../../../core/network/api_response.dart';
import '../../models/delivery_order_model.dart';

abstract class DeliveryRepository {
  Future<ApiResponse<List<DeliveryOrderModel>>> getOrders();

  Future<ApiResponse<DeliveryOrderModel>> getOrderById(String id);

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
