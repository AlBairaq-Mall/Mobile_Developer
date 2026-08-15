import 'package:bhm_supermarket/features/delivery/data/datasources/delivery_remote_datasource.dart';

import '../../../../core/network/api_response.dart';
import '../../domain/repositories/delivery_repository.dart';
import '../../models/delivery_order_model.dart';

class DeliveryRepositoryImpl implements DeliveryRepository {
  DeliveryRepositoryImpl(this._remote);

  final DeliveryRemoteDataSource _remote;

  @override
  Future<ApiResponse<List<DeliveryOrderModel>>> getOrders() {
    return _remote.fetchOrders();
  }

  @override
  Future<ApiResponse<DeliveryOrderModel>> getOrderById(String id) {
    return _remote.fetchOrderById(id);
  }

  @override
  Future<ApiResponse<void>> updateOrderStatus({
    required String orderId,
    required String status,
    String? paymentStatus,
  }) {
    return _remote.updateOrderStatus(
      orderId: orderId,
      status: status,
      paymentStatus: paymentStatus,
    );
  }

  @override
  Future<ApiResponse<void>> assignDriver({
    required String orderId,
    required int deliveryDriverId,
  }) {
    return _remote.assignDriver(
      orderId: orderId,
      deliveryDriverId: deliveryDriverId,
    );
  }
}
