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
    required String addressId,
    required String paymentMethod,
    required double deliveryFee,
    required double discount,
    String? notes,
    required List<Map<String, dynamic>> items,
  }) {
    return _remote.createOrder(
      addressId: addressId,
      paymentMethod: paymentMethod,
      deliveryFee: deliveryFee,
      discount: discount,
      notes: notes,
      items: items,
    );
  }
}
