import '../../../../core/api/api_endpoints.dart';
import '../../../../core/datasource/base_remote_datasource.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/utils/json_parser.dart';
import '../../models/order_model.dart';

class OrderRemoteDataSource extends BaseRemoteDataSource {
  OrderRemoteDataSource(super.dio);

  Future<ApiResponse<List<OrderModel>>> getOrders() =>
      getPaginated<List<OrderModel>>(
        ApiEndpoints.myOrders,
        parser: (json) => JsonParser.list(
          json,
          (e) => OrderModel.fromJson(
            JsonParser.map(e),
          ),
        ),
      );

  Future<ApiResponse<Map<String, dynamic>>> createOrder({
    required String addressId,
    required String paymentMethod,
    required List<Map<String, dynamic>> items,
    required double deliveryFee,
    required double discount,
    String? notes,
    String? couponCode,
  }) =>
      postEnvelope<Map<String, dynamic>>(
        ApiEndpoints.orders,
        data: {
          "location_id": int.parse(addressId),
          "payment_method": paymentMethod,
          "delivery_fee": deliveryFee,
          "discount": discount,
          if (notes != null) "notes": notes,
          "items": items,
          if (couponCode != null) "coupon_code": couponCode,
        },
        parser: (json) => JsonParser.map(json),
      );

  Future<ApiResponse<Map<String, dynamic>>> trackOrder(String orderNumber) =>
      getEnvelope<Map<String, dynamic>>(
        ApiEndpoints.orderTrack(orderNumber),
        parser: (json) => JsonParser.map(json),
      );
}
