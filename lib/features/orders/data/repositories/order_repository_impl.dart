import '../../../../core/network/api_response.dart';
import '../../domain/repositories/order_repository.dart';
import '../../models/order_model.dart';
import '../datasources/order_remote_datasource.dart';

class OrderRepositoryImpl implements OrderRepository {
  OrderRepositoryImpl(this._remote);

  final OrderRemoteDataSource _remote;

  @override
  Future<ApiResponse<List<OrderModel>>> getMyOrders() => _remote.fetchMyOrders();

  @override
  Future<ApiResponse<Map<String, dynamic>>> createOrder({
    required String addressId,
    required String paymentMethod,
    required List<Map<String, dynamic>> items,
    String? couponCode,
  }) =>
      _remote.createOrder(
        addressId: addressId,
        paymentMethod: paymentMethod,
        items: items,
        couponCode: couponCode,
      );

  @override
  Future<ApiResponse<Map<String, dynamic>>> trackOrder(String orderNumber) =>
      _remote.trackOrder(orderNumber);
}
