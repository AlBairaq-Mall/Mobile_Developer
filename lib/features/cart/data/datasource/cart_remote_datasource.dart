// import '../../../../core/api/api_endpoints.dart';
// import '../../../../core/datasource/base_remote_datasource.dart';
// import '../../../../core/network/api_response.dart';
// import '../../../../core/utils/json_parser.dart';

// class CartRemoteDataSource extends BaseRemoteDataSource {
//   CartRemoteDataSource(super.dio);

//   Future<ApiResponse<List<Map<String, dynamic>>>> getCart() =>
//       getEnvelope<List<Map<String, dynamic>>>(
//         ApiEndpoints.cart,
//         parser: (json) => JsonParser.list<Map<String, dynamic>>(
//           json,
//           (e) => JsonParser.map(e),
//         ),
//       );

//   Future<ApiResponse<void>> addItem({
//     required String productId,
//     required String unitId,
//     required int quantity,
//   }) =>
//       postEnvelope<void>(
//         ApiEndpoints.cart,
//         data: {
//           "product_id": int.parse(productId),
//           "unit_id": int.parse(unitId),
//           "quantity": quantity,
//         },
//       );

//   Future<ApiResponse<void>> updateQuantity({
//     required String cartItemId,
//     required int quantity,
//   }) =>
//       putEnvelope<void>(
//         "${ApiEndpoints.cart}/$cartItemId",
//         data: {
//           "quantity": quantity,
//         },
//       );

//   Future<ApiResponse<void>> removeItem(String cartItemId) => deleteEnvelope(
//         "${ApiEndpoints.cart}/$cartItemId",
//       );

//   Future<ApiResponse<void>> clearCart() => deleteEnvelope(
//         "${ApiEndpoints.cart}/clear",
//       );
// }
