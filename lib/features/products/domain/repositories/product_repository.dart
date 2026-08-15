// import '../../../../core/models/product_model.dart';
// import '../../../../core/network/api_response.dart';

// abstract class ProductRepository {
//   Future<ApiResponse<List<ProductModel>>> getProducts({
//     String? categoryId,
//     String? search,
//     int page = 1,
//   });

//   Future<ApiResponse<ProductModel>> getProductById(String id);
// }

import 'package:bhm_supermarket/core/models/product_model.dart';
import '../../../../core/network/api_response.dart';

abstract class ProductRepository {
  Future<ApiResponse<List<ProductModel>>> getProducts({
    String? categoryId,
    String? search,
    int page = 1,
  });

  Future<ApiResponse<ProductModel>> getProductById(String id);
}
