import '../../../../core/models/product_model.dart';
import '../../../../core/network/api_response.dart';
import '../../models/product_unit_model.dart';

abstract class ProductRepository {
  Future<ApiResponse<List<ProductModel>>> getProducts({
    String? categoryId,
    String? search,
    int page = 1,
  });

  Future<ApiResponse<ProductModel>> getProductById(String id);
}
