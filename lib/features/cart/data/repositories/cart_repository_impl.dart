// import 'package:bhm_supermarket/features/cart/data/datasource/cart_remote_datasource.dart';

// import '../../../../core/network/api_response.dart';
// import '../../domain/repositories/cart_repository.dart';

// class CartRepositoryImpl implements CartRepository {
//   CartRepositoryImpl(this._remote);

//   final CartRemoteDataSource _remote;

//   @override
//   Future<ApiResponse<List<Map<String, dynamic>>>> getCart() {
//     return _remote.getCart();
//   }

//   @override
//   Future<ApiResponse<void>> addItem({
//     required String productId,
//     required String unitId,
//     required int quantity,
//   }) {
//     return _remote.addItem(
//       productId: productId,
//       unitId: unitId,
//       quantity: quantity,
//     );
//   }

//   @override
//   Future<ApiResponse<void>> updateQuantity({
//     required String cartItemId,
//     required int quantity,
//   }) {
//     return _remote.updateQuantity(
//       cartItemId: cartItemId,
//       quantity: quantity,
//     );
//   }

//   @override
//   Future<ApiResponse<void>> removeItem(String cartItemId) {
//     return _remote.removeItem(cartItemId);
//   }

//   @override
//   Future<ApiResponse<void>> clearCart() {
//     return _remote.clearCart();
//   }
// }
