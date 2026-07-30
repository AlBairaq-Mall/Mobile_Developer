import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/models/product_model.dart';
import '../../products/domain/repositories/product_repository.dart';

class FavoritesProvider extends ChangeNotifier {
  FavoritesProvider(this._productRepository) {
    _loadFavorites();
  }

  final ProductRepository _productRepository;
  final List<String> _ids = [];
  final Map<String, ProductModel> _cache = {};

  List<String> get ids => List.unmodifiable(_ids);
  List<ProductModel> get products =>
      _ids.map((id) => _cache[id]).whereType<ProductModel>().toList();

  bool isFavorite(String id) => _ids.contains(id);

  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedIds = prefs.getStringList('favorite_ids');
      final cacheJson = prefs.getString('favorite_cache');
      if (savedIds != null) {
        _ids.clear();
        _ids.addAll(savedIds);
      }
      if (cacheJson != null) {
        final Map<String, dynamic> decoded = jsonDecode(cacheJson);
        _cache.clear();
        decoded.forEach((key, value) {
          _cache[key] = ProductModel.fromJson(value);
        });
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading favorites: $e');
    }
  }

  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('favorite_ids', _ids);
      final cacheMap = _cache.map((key, value) => MapEntry(key, value.toJson()));
      await prefs.setString('favorite_cache', jsonEncode(cacheMap));
    } catch (e) {
      debugPrint('Error saving favorites: $e');
    }
  }

  void toggle(String id) {
    if (_ids.contains(id)) {
      _ids.remove(id);
      _cache.remove(id);
      _saveFavorites();
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
      _saveFavorites();
    }
  }
}
