import '../../../../core/api/api_endpoints.dart';
import '../../../../core/datasource/base_remote_datasource.dart';
import '../../../../core/models/product_model.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/utils/json_parser.dart';
import '../../models/product_unit_model.dart';

class ProductRemoteDataSource extends BaseRemoteDataSource {
  ProductRemoteDataSource(super.dio);

  Future<ApiResponse<List<ProductModel>>> fetchProducts({
    String? categoryId,
    String? search,
    int page = 1,
  }) =>
      getEnvelope<List<ProductModel>>(
        ApiEndpoints.products,
        query: {
          if (categoryId != null) 'category_id': categoryId,
          if (search != null && search.isNotEmpty) 'search': search,
          'page': page,
        },
        parser: (json) => JsonParser.list(json, ProductModel.fromJson),
      );

  Future<ApiResponse<ProductModel>> fetchProduct(String id) =>
      getEnvelope<ProductModel>(
        ApiEndpoints.product(id),
        parser: (json) => ProductModel.fromJson(JsonParser.map(json)),
      );

  Future<ApiResponse<List<ProductUnitModel>>> fetchUnits(String itemCode) =>
      getEnvelope<List<ProductUnitModel>>(
        ApiEndpoints.productUnits(itemCode),
        parser: (json) => JsonParser.list(json, ProductUnitModel.fromJson),
      );
}
