import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/models/product_model.dart';
import '../../../core/network/api_response.dart';
import '../../../core/services/secure_storage_service.dart';
import '../../products/models/product_unit_model.dart';
import '../domain/repositories/cart_repository.dart';
import '../models/cart_item_model.dart';

class CartProvider extends ChangeNotifier {
  final CartRepository _repository;

  CartProvider(this._repository) {
    _loadCart();
  }

  final List<CartItemModel> _items = [];
  final Set<String> _processingItems = {};

  bool _busy = false;
  bool _isLoading = false;
  bool _isMerging = false;

  bool get isLoading => _isLoading;
  bool get isMerging => _isMerging;

  List<CartItemModel> get items => List.unmodifiable(_items);

  bool isItemProcessing(String productId, String unitId) {
    return _processingItems.contains('${productId}_$unitId');
  }

  void _setItemProcessing(
    String productId,
    String unitId,
    bool processing,
  ) {
    final key = '${productId}_$unitId';

    if (processing) {
      _processingItems.add(key);
    } else {
      _processingItems.remove(key);
    }

    notifyListeners();
  }

  Future<bool> _hasAuthenticatedSession() async {
    final token = await SecureStorageService.instance.readToken();
    return token != null && token.isNotEmpty;
  }

  int getProductQuantity(String productId, String unitId) {
    final index = getCartItemIndex(productId, unitId);

    if (index == -1) {
      return 0;
    }

    return _items[index].quantity;
  }

  int getCartItemIndex(String productId, String unitId) {
    return _items.indexWhere(
      (item) => item.product.id == productId && item.selectedUnit.id == unitId,
    );
  }

  bool get isEmpty => _items.isEmpty;

  bool get isNotEmpty => _items.isNotEmpty;

  /// عدد أنواع المنتجات في السلة.
  int get itemsCount => _items.length;

  /// إجمالي عدد القطع.
  int get totalQuantity => _items.fold(0, (sum, item) => sum + item.quantity);

  Future<void> _loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cache = prefs.getString('cart_items');

      if (cache != null && cache.isNotEmpty) {
        final decoded = jsonDecode(cache);

        if (decoded is List) {
          _items
            ..clear()
            ..addAll(
              decoded.whereType<Map>().map(
                    (item) => CartItemModel.fromJson(
                      Map<String, dynamic>.from(item),
                    ),
                  ),
            );
        }
      }
    } catch (error, stackTrace) {
      debugPrint('Cart local load error: $error');
      debugPrintStack(stackTrace: stackTrace);
    }

    notifyListeners();
  }

  Future<void> _saveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final encoded = jsonEncode(
        _items.map((item) => item.toJson()).toList(),
      );

      await prefs.setString('cart_items', encoded);
    } catch (error, stackTrace) {
      debugPrint('Cart local save error: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  Future<void> loadFromServer() async {
    if (!await _hasAuthenticatedSession()) {
      return;
    }

    if (_isLoading) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final response = await _repository.getCart();

      response.fold(
        onSuccess: (items) async {
          _items
            ..clear()
            ..addAll(items);

          await _saveCart();
        },
        onError: (message) {
          debugPrint('Cart server load failed: $message');
        },
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<ApiResponse<void>> addItem({
    required ProductModel product,
    required ProductUnitModel selectedUnit,
    required double unitPrice,
    int quantity = 1,
  }) async {
    if (quantity <= 0) {
      return ApiResponse.failure('الكمية غير صحيحة');
    }

    final key = '${product.id}_${selectedUnit.id}';

    if (_busy || _processingItems.contains(key)) {
      return ApiResponse.failure('يرجى الانتظار');
    }

    _busy = true;

    _setItemProcessing(
      product.id,
      selectedUnit.id,
      true,
    );

    try {
      final index = getCartItemIndex(
        product.id,
        selectedUnit.id,
      );

      if (index != -1) {
        _items[index] = _items[index].copyWith(
          quantity: _items[index].quantity + quantity,
        );
      } else {
        _items.add(
          CartItemModel(
            cartId: null,
            product: product,
            selectedUnit: selectedUnit,
            originalPrice: unitPrice,
            discount: 0,
            unitPrice: unitPrice,
            quantity: quantity,
            total: unitPrice * quantity,
          ),
        );
      }

      notifyListeners();
      await _saveCart();

      // Guest:
      // احفظ السلة محلياً فقط ولا تستدعِ API محمية.
      if (!await _hasAuthenticatedSession()) {
        return ApiResponse.success(null);
      }

      final response = await _repository.addToCart(
        productId: product.id,
        unitId: selectedUnit.id,
        quantity: quantity,
      );

      if (!response.isSuccess) {
        await loadFromServer();

        return ApiResponse.failure(
          response.message,
        );
      }

      await loadFromServer();

      return ApiResponse.success(null);
    } catch (error, stackTrace) {
      debugPrint('Cart add error: $error');
      debugPrintStack(stackTrace: stackTrace);

      // لا نمسح السلة المحلية عند خطأ غير متوقع.
      return ApiResponse.failure(
        'تعذر إضافة المنتج إلى السلة',
      );
    } finally {
      _busy = false;

      _setItemProcessing(
        product.id,
        selectedUnit.id,
        false,
      );
    }
  }

  Future<ApiResponse<void>> add(ProductModel product) async {
    late final ProductUnitModel selectedUnit;

    if (product.units.isNotEmpty) {
      selectedUnit = product.units.firstWhere(
        (unit) => unit.isDefault,
        orElse: () => product.units.first,
      );
    } else {
      selectedUnit = ProductUnitModel(
        id: '0',
        itemCode: product.itemCode,
        unitName: product.unit,
        price: product.price,
        package: product.package,
        description: '',
        unit: product.unit,
        isDefault: true,
      );
    }

    return addItem(
      product: product,
      selectedUnit: selectedUnit,
      unitPrice: selectedUnit.price,
    );
  }

  Future<void> increase(int index) async {
    if (index < 0 || index >= _items.length) {
      return;
    }

    final item = _items[index];

    final key = '${item.product.id}_${item.selectedUnit.id}';

    if (_processingItems.contains(key)) {
      return;
    }

    _setItemProcessing(
      item.product.id,
      item.selectedUnit.id,
      true,
    );

    try {
      final newQuantity = item.quantity + 1;

      _items[index] = item.copyWith(
        quantity: newQuantity,
      );

      notifyListeners();
      await _saveCart();

      if (!await _hasAuthenticatedSession()) {
        return;
      }

      if (item.cartId == null) {
        return;
      }

      final response = await _repository.updateQuantity(
        cartId: item.cartId!,
        quantity: newQuantity,
      );

      if (!response.isSuccess) {
        await loadFromServer();
        return;
      }

      await loadFromServer();
    } finally {
      _setItemProcessing(
        item.product.id,
        item.selectedUnit.id,
        false,
      );
    }
  }

  Future<void> decrease(int index) async {
    if (index < 0 || index >= _items.length) {
      return;
    }

    final item = _items[index];

    final key = '${item.product.id}_${item.selectedUnit.id}';

    if (_processingItems.contains(key)) {
      return;
    }

    _setItemProcessing(
      item.product.id,
      item.selectedUnit.id,
      true,
    );

    try {
      if (item.quantity <= 1) {
        _items.removeAt(index);

        notifyListeners();
        await _saveCart();

        if (!await _hasAuthenticatedSession()) {
          return;
        }

        if (item.cartId == null) {
          return;
        }

        final response = await _repository.removeItem(
          item.cartId!,
        );

        if (!response.isSuccess) {
          await loadFromServer();
          return;
        }

        await loadFromServer();
        return;
      }

      final newQuantity = item.quantity - 1;

      _items[index] = item.copyWith(
        quantity: newQuantity,
      );

      notifyListeners();
      await _saveCart();

      if (!await _hasAuthenticatedSession()) {
        return;
      }

      if (item.cartId == null) {
        return;
      }

      final response = await _repository.updateQuantity(
        cartId: item.cartId!,
        quantity: newQuantity,
      );

      if (!response.isSuccess) {
        await loadFromServer();
        return;
      }

      await loadFromServer();
    } finally {
      _setItemProcessing(
        item.product.id,
        item.selectedUnit.id,
        false,
      );
    }
  }

  Future<void> setQuantity({
    required String productId,
    required String unitId,
    required int quantity,
  }) async {
    final index = getCartItemIndex(productId, unitId);

    // لا يوجد المنتج في السلة.
    if (index == -1) {
      return;
    }

    final item = _items[index];
    final key = '${productId}_$unitId';

    if (_processingItems.contains(key)) {
      return;
    }

    if (quantity <= 0) {
      await decrease(index);
      return;
    }

    if (quantity == item.quantity) {
      return;
    }

    _setItemProcessing(productId, unitId, true);

    try {
      _items[index] = item.copyWith(
        quantity: quantity,
      );

      notifyListeners();
      await _saveCart();

      // Guest: local cart فقط.
      if (!await _hasAuthenticatedSession()) {
        return;
      }

      // إذا كان العنصر موجودًا على السيرفر، حدّثه.
      if (item.cartId != null) {
        final response = await _repository.updateQuantity(
          cartId: item.cartId!,
          quantity: quantity,
        );

        if (!response.isSuccess) {
          await loadFromServer();
          return;
        }

        await loadFromServer();
      }
    } finally {
      _setItemProcessing(productId, unitId, false);
    }
  }

  Future<void> clear() async {
    _items.clear();

    notifyListeners();
    await _saveCart();

    // Guest: local clear only.
    if (!await _hasAuthenticatedSession()) {
      return;
    }

    try {
      await _repository.clearCart();
      await loadFromServer();
    } catch (error, stackTrace) {
      debugPrint('Cart clear error: $error');
      debugPrintStack(stackTrace: stackTrace);
    }
  }

  /// يدمج السلة المحلية الخاصة بالضيف مع السلة الموجودة على السيرفر.
  ///
  /// يتم استدعاؤه مرة واحدة بعد نجاح Login/Register.
  Future<void> mergeGuestCart() async {
    if (_isMerging) {
      return;
    }

    if (!await _hasAuthenticatedSession()) {
      return;
    }

    if (_items.isEmpty) {
      await loadFromServer();
      return;
    }

    _isMerging = true;
    notifyListeners();

    try {
      final localItems = List<CartItemModel>.from(_items);

      // نقرأ سلة السيرفر أولاً.
      final serverResponse = await _repository.getCart();

      if (!serverResponse.isSuccess || serverResponse.data == null) {
        return;
      }

      final serverItems = serverResponse.data!;

      // نبدأ من سلة السيرفر ونضيف/نزيد كميات السلة المحلية.
      _items
        ..clear()
        ..addAll(serverItems);

      for (final localItem in localItems) {
        final serverIndex = _items.indexWhere(
          (serverItem) =>
              serverItem.product.id == localItem.product.id &&
              serverItem.selectedUnit.id == localItem.selectedUnit.id,
        );

        if (serverIndex == -1) {
          final response = await _repository.addToCart(
            productId: localItem.product.id,
            unitId: localItem.selectedUnit.id,
            quantity: localItem.quantity,
          );

          if (response.isSuccess) {
            // سيُحمّل لاحقاً من السيرفر.
          }

          continue;
        }

        final serverItem = _items[serverIndex];
        final mergedQuantity = serverItem.quantity + localItem.quantity;

        if (serverItem.cartId != null) {
          final response = await _repository.updateQuantity(
            cartId: serverItem.cartId!,
            quantity: mergedQuantity,
          );

          if (response.isSuccess) {
            _items[serverIndex] = serverItem.copyWith(
              quantity: mergedQuantity,
            );
          }
        }
      }

      await loadFromServer();
    } catch (error, stackTrace) {
      debugPrint('Guest cart merge error: $error');
      debugPrintStack(stackTrace: stackTrace);
    } finally {
      _isMerging = false;
      notifyListeners();
    }
  }

  double get originalSubtotal {
    return _items.fold(
      0.0,
      (sum, item) => sum + (item.originalPrice * item.quantity),
    );
  }

  double get offerDiscount {
    return _items.fold(
      0.0,
      (sum, item) => sum + (item.discountPerUnit * item.quantity),
    );
  }

  double get subtotal {
    return _items.fold(
      0.0,
      (sum, item) => sum + (item.unitPrice * item.quantity),
    );
  }

  double get deliveryFee => 500;

  double get grandTotal => subtotal + deliveryFee;
}
