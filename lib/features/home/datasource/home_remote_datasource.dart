import '../../../core/API/api_client.dart';
import '../../../core/API/api_endpoints.dart';

class HomeRemoteDatasource {
  Future<dynamic> getProducts() async {
    final response = await ApiClient.get(ApiEndpoints.products);

    return response.data;
  }
}
