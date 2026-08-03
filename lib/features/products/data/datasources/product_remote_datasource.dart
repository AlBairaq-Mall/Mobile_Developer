import '../../../../core/api/api_endpoints.dart';
import '../../../../core/datasource/base_remote_datasource.dart';
import '../../../../core/models/product_model.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/utils/json_parser.dart';

class ProductRemoteDataSource extends BaseRemoteDataSource {
  ProductRemoteDataSource(super.dio);

  Future<ApiResponse<List<ProductModel>>> fetchProducts({
    String? categoryId,
    String? search,
    int page = 1,
  }) {
    return getPaginated<List<ProductModel>>(
      ApiEndpoints.products,
      query: {
        if (categoryId != null) 'category_id': categoryId,
        if (search != null && search.isNotEmpty) 'search': search,
        'page': page,
      },
      parser: (json) => JsonParser.list(json, ProductModel.fromJson),
    );
  }

  Future<ApiResponse<ProductModel>> fetchProduct(String id) =>
      getPaginated<ProductModel>(
        ApiEndpoints.product(id),
        parser: (json) => ProductModel.fromJson(JsonParser.map(json)),
      );
}
