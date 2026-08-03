import 'dart:convert';
import 'package:bhm_supermarket/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/models/product_model.dart';
import '../../products/domain/repositories/product_repository.dart';

class FavoritesProvider extends ChangeNotifier {
  final FavoritesRepository _repository;
  final ProductRepository _productRepository;

  FavoritesProvider(
    this._repository,
    this._productRepository,
  ) {
    _loadFavorites();
  }
  final List<String> _ids = [];
  final Map<String, ProductModel> _cache = {};

  final Map<String, String> _favoriteIds = {};

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<String> get ids => List.unmodifiable(_ids);
  List<ProductModel> get products =>
      _ids.map((id) => _cache[id]).whereType<ProductModel>().toList();

  bool isFavorite(String id) => _ids.contains(id);

  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final ids = prefs.getStringList('favorite_ids');

      final cache = prefs.getString('favorite_cache');

      if (ids != null) {
        _ids
          ..clear()
          ..addAll(ids);
      }

      if (cache != null) {
        final decoded = jsonDecode(cache);

        _cache.clear();

        (decoded as Map<String, dynamic>).forEach((key, value) {
          _cache[key] = ProductModel.fromJson(value);
        });
      }
    } catch (_) {}

    notifyListeners();

    await loadFromServer();
  }

  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('favorite_ids', _ids);
      final cacheMap =
          _cache.map((key, value) => MapEntry(key, value.toJson()));
      await prefs.setString('favorite_cache', jsonEncode(cacheMap));
    } catch (e) {
      debugPrint('Error saving favorites: $e');
    }
  }

  Future<void> loadFromServer() async {
    _isLoading = true;

    notifyListeners();

    final response = await _repository.getFavorites();

    response.fold(
      onSuccess: (products) async {
        _ids.clear();

        _cache.clear();

        for (final product in products) {
          _ids.add(product.id);

          _cache[product.id] = product;

          if (product.favoriteId != null) {
            _favoriteIds[product.id] = product.favoriteId!;
          }
        }

        await _saveFavorites();
      },
      onError: (_) {},
    );

    _isLoading = false;

    notifyListeners();
  }

  Future<void> toggle(String productId) async {
    // ===== حذف من المفضلة =====

    if (_ids.contains(productId)) {
      final favoriteId = _favoriteIds[productId];

      _ids.remove(productId);

      _cache.remove(productId);

      notifyListeners();

      await _saveFavorites();

      if (favoriteId != null) {
        final response = await _repository.removeFavorite(
          favoriteId: favoriteId,
        );

        if (response.isSuccess) {
          await loadFromServer();
        }
      }

      return;
    }

    // ===== إضافة للمفضلة =====

    _ids.add(productId);

    notifyListeners();

    await _loadProduct(productId);

    final response = await _repository.addFavorite(
      productId: productId,
    );

    if (response.isSuccess) {
      await loadFromServer();
    }
  }

  Future<void> _loadProduct(String id) async {
    final response = await _productRepository.getProductById(id);

    if (response.isSuccess && response.data != null) {
      _cache[id] = response.data!;

      notifyListeners();

      await _saveFavorites();
    }
  }
}
