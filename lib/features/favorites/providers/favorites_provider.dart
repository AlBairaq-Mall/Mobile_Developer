import 'package:flutter/material.dart';

import '../../../core/models/product_model.dart';
import '../../products/domain/repositories/product_repository.dart';

class FavoritesProvider extends ChangeNotifier {
  FavoritesProvider(this._productRepository);

  final ProductRepository _productRepository;
  final List<String> _ids = [];
  final Map<String, ProductModel> _cache = {};

  List<String> get ids => List.unmodifiable(_ids);
  List<ProductModel> get products =>
      _ids.map((id) => _cache[id]).whereType<ProductModel>().toList();

  bool isFavorite(String id) => _ids.contains(id);

  void toggle(String id) {
    if (_ids.contains(id)) {
      _ids.remove(id);
      _cache.remove(id);
    } else {
      _ids.add(id);
      _loadProduct(id);
    }
    notifyListeners();
  }

  Future<void> _loadProduct(String id) async {
    final response = await _productRepository.getProductById(id);
    if (response.isSuccess && response.data != null) {
      _cache[id] = response.data!;
      notifyListeners();
    }
  }
}
