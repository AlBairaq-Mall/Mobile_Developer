import '../../../../core/network/api_response.dart';
import '../../../delivery/models/delivery_order_model.dart';

abstract class AdminOrdersRepository {
  Future<ApiResponse<List<DeliveryOrderModel>>> getOrders();
}
