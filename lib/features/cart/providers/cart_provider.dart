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

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<CartItemModel> get items => List.unmodifiable(_items);

  bool get isEmpty => _items.isEmpty;

  bool get isNotEmpty => _items.isNotEmpty;

  int get itemsCount => _items.length;

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
    } catch (_) {}

    notifyListeners();

    await loadFromServer();
  }

  Future<void> _saveCart() async {
    final prefs = await SharedPreferences.getInstance();

    final encoded = jsonEncode(
      _items.map((e) => e.toJson()).toList(),
    );

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
    final index = _items.indexWhere(
      (e) => e.product.id == product.id && e.selectedUnit.id == selectedUnit.id,
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
          unitPrice: unitPrice,
          quantity: quantity,
          price: unitPrice,
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

      return ApiResponse.success(null);
    }

// إعادة الحالة المحلية كما كانت
    await loadFromServer();

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

    _items[index] = item.copyWith(
      quantity: item.quantity + 1,
    );

    notifyListeners();

    await _saveCart();

    if (item.cartId != null) {
      final response = await _repository.updateQuantity(
        cartId: item.cartId!,
        quantity: item.quantity + 1,
      );

      if (response.isSuccess) {
        await loadFromServer();
      } else {
        await loadFromServer();
      }
    }
  }

  Future<void> decrease(int index) async {
    final item = _items[index];

    // إذا أصبحت صفر نحذفه
    if (item.quantity == 1) {
      _items.removeAt(index);

      notifyListeners();

      await _saveCart();

      if (item.cartId != null) {
        final response = await _repository.removeItem(
          item.cartId!,
        );

        if (response.isSuccess) {
          await loadFromServer();
        } else {
          await loadFromServer();
        }
      }

      return;
    }

    // تقليل الكمية محلياً
    _items[index] = item.copyWith(
      quantity: item.quantity - 1,
    );

    notifyListeners();

    await _saveCart();

    if (item.cartId != null) {
      final response = await _repository.updateQuantity(
        cartId: item.cartId!,
        quantity: item.quantity - 1,
      );

      if (response.isSuccess) {
        await loadFromServer();
      } else {
        await loadFromServer();
      }
    }
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

  double get subtotal => _items.fold(
        0.0,
        (sum, item) => sum + item.totalPrice,
      );

  double get deliveryFee {
    // سيتم لاحقاً أخذها من الإعدادات أو من الـ API
    return 500;
  }

  double get grandTotal => subtotal + deliveryFee;
}
