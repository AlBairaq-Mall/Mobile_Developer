// import '../../../../core/models/product_model.dart';
// import '../../../../core/network/api_response.dart';
// import '../../domain/repositories/product_repository.dart';
// import '../datasources/product_remote_datasource.dart';

// class ProductRepositoryImpl implements ProductRepository {
//   ProductRepositoryImpl(this._remote);

//   final ProductRemoteDataSource _remote;

//   @override
//   Future<ApiResponse<List<ProductModel>>> getProducts({
//     String? categoryId,
//     String? search,
//     int page = 1,
//   }) =>
//       _remote.fetchProducts(categoryId: categoryId, search: search, page: page);

//   @override
//   Future<ApiResponse<ProductModel>> getProductById(String id) =>
//       _remote.fetchProduct(id);
// }

// import '../../../../core/models/product_model.dart';
// import '../../../../core/network/api_response.dart';
// import '../../domain/repositories/product_repository.dart';
// import '../datasources/product_remote_datasource.dart';

// class ProductRepositoryImpl implements ProductRepository {
//   ProductRepositoryImpl(this._remote);

//   final ProductRemoteDataSource _remote;

//   @override
//   Future<ApiResponse<List<ProductModel>>> getProducts({
//     String? categoryId,
//     String? search,
//     int page = 1,
//     bool forceRefresh = false,
//   }) {
//     return _remote.fetchProducts(
//       categoryId: categoryId,
//       search: search,
//       page: page,
//       forceRefresh: forceRefresh,
//     );
//   }

//   @override
//   Future<ApiResponse<ProductModel>> getProductById(
//     String id, {
//     bool forceRefresh = false,
//   }) {
//     return _remote.fetchProduct(
//       id,
//       forceRefresh: forceRefresh,
//     );
//   }
// }

import 'package:bhm_supermarket/core/models/product_model.dart';

import '../../../../core/network/api_response.dart';
import '../../domain/repositories/product_repository.dart';
import '../datasources/product_remote_datasource.dart';

class ProductRepositoryImpl implements ProductRepository {
  ProductRepositoryImpl(this._remote);

  final ProductRemoteDataSource _remote;

  @override
  Future<ApiResponse<List<ProductModel>>> getProducts({
    String? categoryId,
    String? search,
    int page = 1,
  }) {
    return _remote.fetchProducts(
      categoryId: categoryId,
      search: search,
      page: page,
    );
  }

  @override
  Future<ApiResponse<ProductModel>> getProductById(String id) {
    return _remote.fetchProduct(id);
  }
}
