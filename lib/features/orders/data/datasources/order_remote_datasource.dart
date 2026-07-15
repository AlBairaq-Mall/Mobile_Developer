import '../../../../core/api/api_endpoints.dart';
import '../../../../core/datasource/base_remote_datasource.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/utils/json_parser.dart';
import '../../models/order_model.dart';

class OrderRemoteDataSource extends BaseRemoteDataSource {
  OrderRemoteDataSource(super.dio);

  Future<ApiResponse<List<OrderModel>>> fetchMyOrders() =>
      getEnvelope<List<OrderModel>>(
        ApiEndpoints.orders,
        parser: (json) => JsonParser.list(json, OrderModel.fromJson),
      );

  Future<ApiResponse<Map<String, dynamic>>> createOrder({
    required String addressId,
    required String paymentMethod,
    required List<Map<String, dynamic>> items,
    String? couponCode,
  }) =>
      postEnvelope<Map<String, dynamic>>(
        ApiEndpoints.orders,
        data: {
          'address_id': addressId,
          'payment_method': paymentMethod,
          'items': items,
          if (couponCode != null) 'coupon_code': couponCode,
        },
        parser: (json) => JsonParser.map(json),
      );

  Future<ApiResponse<Map<String, dynamic>>> trackOrder(String orderNumber) =>
      getEnvelope<Map<String, dynamic>>(
        ApiEndpoints.orderTrack(orderNumber),
        parser: (json) => JsonParser.map(json),
      );
}
