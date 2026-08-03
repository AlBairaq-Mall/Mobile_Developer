import 'package:flutter/material.dart';

import '../../../core/models/product_model.dart';
import '../domain/repositories/product_repository.dart';
import '../models/product_unit_model.dart';

class ProductProvider extends ChangeNotifier {
  ProductProvider(this._repository);

  final ProductRepository _repository;

  ProductModel? _product;
  List<ProductUnitModel> _units = [];
  List<ProductModel> _related = [];

  List<ProductModel> _products = [];
  List<ProductModel> get products => _products;

  bool _isLoading = false;
  String? _error;

  int _selectedUnitIndex = 0;
  int _quantity = 1;

  ProductModel? get product => _product;

  List<ProductUnitModel> get units => _units;

  List<ProductModel> get related => _related;

  bool get isLoading => _isLoading;

  String? get error => _error;

  int get quantity => _quantity;

  int get selectedUnitIndex => _selectedUnitIndex;

  ProductUnitModel? get selectedUnit =>
      _units.isEmpty ? null : _units[_selectedUnitIndex];

  Future<void> loadProduct(String productId) async {
    _isLoading = true;
    _error = null;
    _isLoading = true;
    _error = null;

    notifyListeners();

    final productResponse = await _repository.getProductById(productId);

    if (!productResponse.isSuccess || productResponse.data == null) {
      _product = null;
      _units = [];
      _related = [];
      _error = productResponse.message;
      _isLoading = false;
      notifyListeners();
      return;
    }

    _product = productResponse.data!;
    // الوحدات تأتي مع المنتج نفسه من Laravel
    _units = _product!.units;

    // تحميل المنتجات ذات الصلة إذا كان القسم معروفاً
    if (_product!.categoryId.isNotEmpty) {
      final relatedResponse = await _repository.getProducts(
        categoryId: _product!.categoryId,
      );
      _related = (relatedResponse.data ?? [])
          .where((e) => e.id != _product!.id)
          .take(6)
          .toList();
    } else {
      _related = [];
    }

    _selectedUnitIndex = _units.isNotEmpty ? 0 : 0;
    _quantity = 1;
    _isLoading = false;
    notifyListeners();
  }

  void selectUnit(int index) {
    if (index < 0 || index >= _units.length) return;

    if (_selectedUnitIndex == index) return;

    _selectedUnitIndex = index;
    notifyListeners();
  }

  void increaseQuantity() {
    _quantity++;
    notifyListeners();
  }

  void decreaseQuantity() {
    if (_quantity > 1) {
      _quantity--;
      notifyListeners();
    }
  }

  void reset() {
    _product = null;
    _units = [];
    _related = [];
    _selectedUnitIndex = 0;
    _quantity = 1;
    _error = null;
    _isLoading = false;
    notifyListeners();
  }

  Future<void> loadCategory(String categoryId) async {
    try {
      _products.clear();

      _isLoading = true;
      _error = null;
      notifyListeners();

      final response = await _repository.getProducts(
        categoryId: categoryId,
      );

      if (response.isSuccess) {
        _products = response.data ?? [];
      } else {
        _products = [];
        _error = response.message;
      }
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());

      _products = [];
      _error = e.toString();
    }

    _isLoading = false;
    notifyListeners();
  }
}
