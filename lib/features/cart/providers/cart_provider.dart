import 'package:flutter/material.dart';

import '../models/cart_item_model.dart';
import '../../../core/models/product_model.dart';

class CartProvider extends ChangeNotifier {
  final List<CartItemModel> _items = [];
  List<CartItemModel> get items => _items;
  int get itemsCount => _items.length;

  void addItem({
    required ProductModel product,
    required String unit,
    required double unitPrice,
    int quantity = 1,   // عداد الكمية من شاشة تفاصيل المنتج
  }) {
    final index = _items.indexWhere(
      (item) => item.product.id == product.id && item.unit == unit,
    );

    if (index != -1) {
      final old = _items[index];

      _items[index] = CartItemModel(
        product: old.product,
        unit: old.unit,
        unitPrice: old.unitPrice,
        quantity: old.quantity + 1,
      );
    } else {
      _items.add(
        CartItemModel(
          product: product,
          unit: unit,
          unitPrice: unitPrice,
          quantity: 1,
        ),
      );
    }

    notifyListeners();
  }

  void add(ProductModel product) {
    addItem(product: product, unit: product.unit, unitPrice: product.price);
  }

  void increase(int index) {
    final item = _items[index];

    _items[index] = CartItemModel(
      product: item.product,
      unit: item.unit,
      unitPrice: item.unitPrice,
      quantity: item.quantity + 1,
    );

    notifyListeners();
  }

  void decrease(int index) {
    final item = _items[index];

    if (item.quantity <= 1) {
      _items.removeAt(index);
    } else {
      _items[index] = CartItemModel(
        product: item.product,
        unit: item.unit,
        unitPrice: item.unitPrice,
        quantity: item.quantity - 1,
      );
    }

    notifyListeners();
  }

  void clear() {
    _items.clear();
    notifyListeners();
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
