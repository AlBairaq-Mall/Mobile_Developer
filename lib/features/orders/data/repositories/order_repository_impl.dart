import 'package:bhm_supermarket/core/network/api_response.dart';
import 'package:bhm_supermarket/features/orders/data/datasources/order_remote_datasource.dart';
import 'package:bhm_supermarket/features/orders/domain/repositories/order_repository.dart';
import 'package:bhm_supermarket/features/orders/models/order_model.dart';

class OrderRepositoryImpl implements OrderRepository {
  final OrderRemoteDataSource _remote;

  OrderRepositoryImpl(this._remote);

  @override
  Future<ApiResponse<List<OrderModel>>> getOrders() {
    return _remote.getOrders();
  }

  @override
  Future<ApiResponse<Map<String, dynamic>>> createOrder({
    required String locationId,
    required String paymentMethod,
    String? notes,
    String? couponCode,
    required List<Map<String, dynamic>> items,
  }) {
    return _remote.createOrder(
      locationId: locationId,
      paymentMethod: paymentMethod,
      notes: notes,
      items: items,
      couponCode: couponCode,
    );
  }
}
