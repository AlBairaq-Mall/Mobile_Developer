import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/models/product_model.dart';
import '../../../core/network/api_response.dart';
import '../../products/models/product_unit_model.dart';
import '../domain/repositories/cart_repository.dart';
import '../models/cart_item_model.dart';

class CartProvider extends ChangeNotifier {
  final CartRepository _repository;

  CartProvider(this._repository) {
    _loadCart();
  }

  final List<CartItemModel> _items = [];
  bool _busy = false;
  bool _isLoading = false;
  final Set<String> _processingItems = {};

  bool get isLoading => _isLoading;

  List<CartItemModel> get items => List.unmodifiable(_items);

  bool isItemProcessing(String productId, String unitId) {
    return _processingItems.contains('${productId}_$unitId');
  }

  void _setItemProcessing(String productId, String unitId, bool processing) {
    final key = '${productId}_$unitId';
    if (processing) {
      _processingItems.add(key);
    } else {
      _processingItems.remove(key);
    }
    notifyListeners();
  }

  int getProductQuantity(String productId, String unitId) {
    final index = getCartItemIndex(productId, unitId);
    if (index != -1) {
      return _items[index].quantity;
    }
    return 0;
  }

  int getCartItemIndex(String productId, String unitId) {
    return _items.indexWhere(
      (e) => e.product.id == productId && e.selectedUnit.id == unitId,
    );
  }

  bool get isEmpty => _items.isEmpty;

  bool get isNotEmpty => _items.isNotEmpty;
  // لما نريد في السله يطبع عدد الانواع التي اشتراها
  int get itemsCount => _items.length;
  // لما نريد في السله يطبع عدد القطع
  // int get totalQuantity => _items.fold(0, (sum, item) => sum + item.quantity);

  Future<void> _loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final cache = prefs.getString('cart_items');

      if (cache != null) {
        final decoded = jsonDecode(cache);

        _items
          ..clear()
          ..addAll(
            (decoded as List).map((e) => CartItemModel.fromJson(e)).toList(),
          );
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }

    notifyListeners();

    // لا نطلب من السيرفر في الـ constructor — خففنا request عند فتح التطبيق.
    // سيتم استدعاء loadFromServer() عند فتح شاشة السلة أو بعد عملية تعديل.
  }

  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();

    final encoded = jsonEncode(_items.map((e) => e.toJson()).toList());

    await prefs.setString('cart_items', encoded);
  }

  Future<void> loadFromServer() async {
    _isLoading = true;

    notifyListeners();

    final response = await _repository.getCart();

    response.fold(
      onSuccess: (items) async {
        _items
          ..clear()
          ..addAll(items);

        await _saveCart();
      },
      onError: (message) {
        debugPrint(message);
      },
    );

    _isLoading = false;

    notifyListeners();
  }

  int get totalQuantity => _items.fold(0, (sum, item) => sum + item.quantity);

  Future<ApiResponse<void>> addItem({
    required ProductModel product,
    required ProductUnitModel selectedUnit,
    required double unitPrice,
    int quantity = 1,
  }) async {
    final key = '${product.id}_${selectedUnit.id}';
    if (_busy || _processingItems.contains(key)) {
      return ApiResponse.failure("يرجى الانتظار");
    }

    _busy = true;
    _setItemProcessing(product.id, selectedUnit.id, true);
    final index = getCartItemIndex(product.id, selectedUnit.id);

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

    final response = await _repository.addToCart(
      productId: product.id,
      unitId: selectedUnit.id,
      quantity: quantity,
    );

    if (response.isSuccess) {
      await loadFromServer();
      _busy = false;
      _setItemProcessing(product.id, selectedUnit.id, false);
      return ApiResponse.success(null);
    }

    // إعادة الحالة المحلية كما كانت
    await loadFromServer();
    _busy = false;
    _setItemProcessing(product.id, selectedUnit.id, false);
    return ApiResponse.failure(response.message);
  }

  Future<ApiResponse<void>> add(ProductModel product) async {
    ProductUnitModel selectedUnit;

    if (product.units.isNotEmpty) {
      selectedUnit = product.units.firstWhere(
        (u) => u.isDefault,
        orElse: () => product.units.first,
      );
    } else {
      selectedUnit = ProductUnitModel(
        id: "0",
        itemCode: product.itemCode,
        unitName: product.unit,
        price: product.price,
        package: product.package,
        description: "",
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
    final item = _items[index];
    final key = '${item.product.id}_${item.selectedUnit.id}';
    if (_processingItems.contains(key)) return;

    _setItemProcessing(item.product.id, item.selectedUnit.id, true);

    _items[index] = item.copyWith(quantity: item.quantity + 1);

    notifyListeners();

    await _saveCart();

    if (item.cartId != null) {
      final response = await _repository.updateQuantity(
        cartId: item.cartId!,
        quantity: item.quantity + 1,
      );

      if (!response.isSuccess) {
        // Rollback on failure
        await loadFromServer();
      } else {
        await loadFromServer();
      }
    }
    
    _setItemProcessing(item.product.id, item.selectedUnit.id, false);
  }

  Future<void> decrease(int index) async {
    final item = _items[index];
    final key = '${item.product.id}_${item.selectedUnit.id}';
    if (_processingItems.contains(key)) return;

    _setItemProcessing(item.product.id, item.selectedUnit.id, true);

    // إذا أصبحت صفر نحذفه
    if (item.quantity == 1) {
      _items.removeAt(index);

      notifyListeners();

      await _saveCart();

      if (item.cartId != null) {
        final response = await _repository.removeItem(item.cartId!);
        
        if (!response.isSuccess) {
           await loadFromServer();
        } else {
           await loadFromServer();
        }
      }

      _setItemProcessing(item.product.id, item.selectedUnit.id, false);
      return;
    }

    // تقليل الكمية محلياً
    _items[index] = item.copyWith(quantity: item.quantity - 1);

    notifyListeners();

    await _saveCart();

    if (item.cartId != null) {
      final response = await _repository.updateQuantity(
        cartId: item.cartId!,
        quantity: item.quantity - 1,
      );
      
      if (!response.isSuccess) {
         await loadFromServer();
      } else {
         await loadFromServer();
      }
    }
    
    _setItemProcessing(item.product.id, item.selectedUnit.id, false);
  }

  Future<void> clear() async {
    // حذف محلي مباشرة
    _items.clear();

    notifyListeners();

    await _saveCart();

    // حذف من السيرفر
    await _repository.clearCart();

    await loadFromServer();
  }

  /// المجموع قبل خصومات العروض
  double get originalSubtotal {
    return _items.fold(
      0.0,
      (sum, item) => sum + (item.originalPrice * item.quantity),
    );
  }

  /// إجمالي خصومات العروض
  double get offerDiscount {
    return _items.fold(
      0.0,
      (sum, item) => sum + (item.discountPerUnit * item.quantity),
    );
  }

  /// المجموع بعد خصومات العروض
  double get subtotal {
    return _items.fold(
      0.0,
      (sum, item) => sum + (item.unitPrice * item.quantity),
    );
  }

  double get deliveryFee {
    return 500;
  }

  /// الإجمالي النهائي بعد خصم العروض + التوصيل
  double get grandTotal {
    return subtotal + deliveryFee;
  }
}
