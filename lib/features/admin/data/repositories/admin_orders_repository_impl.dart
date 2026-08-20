import '../../../../core/network/api_response.dart';
import '../../../delivery/models/delivery_order_model.dart';
import '../../domain/repositories/admin_orders_repository.dart';
import '../datasources/admin_orders_remote_datasource.dart';

class AdminOrdersRepositoryImpl implements AdminOrdersRepository {
  final AdminOrdersRemoteDataSource _remote;
  AdminOrdersRepositoryImpl(this._remote);

  @override
  Future<ApiResponse<List<DeliveryOrderModel>>> getOrders() {
    return _remote.getOrders();
  }
}
