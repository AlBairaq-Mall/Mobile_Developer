
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/datasource/base_remote_datasource.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/utils/json_parser.dart';
import '../../../delivery/models/delivery_order_model.dart';

class AdminOrdersRemoteDataSource extends BaseRemoteDataSource {
  AdminOrdersRemoteDataSource(super.dio);

  Future<ApiResponse<List<DeliveryOrderModel>>> getOrders() {
    return getPaginated<List<DeliveryOrderModel>>(
      ApiEndpoints.adminOrders,
      parser: (json) => JsonParser.list(
        json,
        DeliveryOrderModel.fromJson,
      ),
    );
  }
}
