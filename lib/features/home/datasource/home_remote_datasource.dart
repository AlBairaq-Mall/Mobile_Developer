import '../../../core/api/api_client.dart';
import '../../../core/api/api_endpoints.dart';

class HomeRemoteDatasource {
  Future<List<dynamic>> getProducts() async {
    final response = await ApiClient.get(
      ApiEndpoints.products,
    );

    return response.data['data'];
  }
}
