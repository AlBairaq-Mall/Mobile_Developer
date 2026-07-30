import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../models/cart_item_model.dart';
import '../../../core/models/product_model.dart';
import '../../products/models/product_unit_model.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItemModel> _items = [];
  List<CartItemModel> get items => _items;
  bool get isEmpty => _items.isEmpty;

  bool get isNotEmpty => _items.isNotEmpty;
  int get itemsCount => _items.length;

  CartProvider() {
    _loadCart();
  }

  Future<void> _loadCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final cartJson = prefs.getString('cart_items');
      if (cartJson != null) {
        final List<dynamic> decoded = jsonDecode(cartJson);
        _items.clear();
        _items.addAll(decoded.map((item) => CartItemModel.fromJson(item)));
        notifyListeners();
      }
    } catch (e) {
      debugPrint('Error loading cart: $e');
    }
  }

  Future<void> _saveCart() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String encoded = jsonEncode(_items.map((item) => item.toJson()).toList());
      await prefs.setString('cart_items', encoded);
    } catch (e) {
      debugPrint('Error saving cart: $e');
    }
  }

  int get totalQuantity {
    return _items.fold(
      0,
      (sum, item) => sum + item.quantity,
    );
  }

  void addItem({
    required ProductModel product,
    required ProductUnitModel selectedUnit,
    required double unitPrice,
    int quantity = 1,
  }) {
    final index = _items.indexWhere(
      (item) =>
          item.product.id == product.id &&
          item.selectedUnit.id == selectedUnit.id,
    );

    if (index != -1) {
      final old = _items[index];

      _items[index] = CartItemModel(
        product: old.product,
        selectedUnit: old.selectedUnit,
        unitPrice: old.unitPrice,
        quantity: old.quantity + quantity,
      );
    } else {
      _items.add(
        CartItemModel(
          product: product,
          selectedUnit: selectedUnit,
          unitPrice: unitPrice,
          quantity: quantity,
        ),
      );
    }

    notifyListeners();
    _saveCart();
  }

  void add(ProductModel product) {
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

    addItem(
      product: product,
      selectedUnit: selectedUnit,
      unitPrice: selectedUnit.price,
    );
  }

  void increase(int index) {
    final item = _items[index];

    _items[index] = CartItemModel(
      product: item.product,
      selectedUnit: item.selectedUnit,
      unitPrice: item.unitPrice,
      quantity: item.quantity + 1,
    );

    notifyListeners();
    _saveCart();
  }

  void decrease(int index) {
    final item = _items[index];

    if (item.quantity <= 1) {
      _items.removeAt(index);
    } else {
      _items[index] = CartItemModel(
        product: item.product,
        selectedUnit: item.selectedUnit,
        unitPrice: item.unitPrice,
        quantity: item.quantity - 1,
      );
    }

    notifyListeners();
    _saveCart();
  }

  void clear() {
    _items.clear();
    notifyListeners();
    _saveCart();
  }

  double get subtotal {
    double total = 0;

    for (final item in _items) {
      total += item.totalPrice;
    }

    return total;
  }

  double get deliveryFee => 500;

  double get grandTotal => subtotal + deliveryFee;
}
