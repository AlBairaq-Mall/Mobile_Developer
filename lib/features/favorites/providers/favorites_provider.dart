import 'dart:convert';
import 'package:bhm_supermarket/features/favorites/domain/repositories/favorites_repository.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../core/models/product_model.dart';
import '../../products/domain/repositories/product_repository.dart';
import 'package:bhm_supermarket/core/services/secure_storage_service.dart';

Future<bool> _hasAuthenticatedSession() async {
  final token = await SecureStorageService.instance.readToken();
  return token != null && token.isNotEmpty;
}

class FavoritesProvider extends ChangeNotifier {
  final FavoritesRepository _repository;
  final ProductRepository _productRepository;

  FavoritesProvider(this._repository, this._productRepository) {
    _loadFavorites();
  }
  bool _busy = false;
  final List<String> _ids = [];
  // O(1) lookup mirror of _ids — kept in sync in every mutation site.
  final Set<String> _idsSet = {};
  final Map<String, ProductModel> _cache = {};

  final Map<String, String> _favoriteIds = {};

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  List<String> get ids => List.unmodifiable(_ids);
  List<ProductModel> get products =>
      _ids.map((id) => _cache[id]).whereType<ProductModel>().toList();

  bool isFavorite(String id) => _idsSet.contains(id); // O(1)

  Future<void> _loadFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();

      final ids = prefs.getStringList('favorite_ids');

      final cache = prefs.getString('favorite_cache');

      if (ids != null) {
        _ids
          ..clear()
          ..addAll(ids);
        _idsSet
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
    } catch (e, s) {
      debugPrint(e.toString());
      debugPrint(s.toString());
    }

    notifyListeners();

    // لا نطلب من السيرفر في الـ constructor — خففنا request عند فتح التطبيق.
    // سيتم استدعاء loadFromServer() عند فتح شاشة المفضلة أو عند تفعيل toggle.
  }

  Future<void> _saveFavorites() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      await prefs.setStringList('favorite_ids', _ids);
      final cacheMap = _cache.map(
        (key, value) => MapEntry(key, value.toJson()),
      );
      await prefs.setString('favorite_cache', jsonEncode(cacheMap));
    } catch (e) {
      debugPrint('Error saving favorites: $e');
    }
  }

  Future<void> loadFromServer() async {
    if (!await _hasAuthenticatedSession()) {
      return;
    }
    _isLoading = true;

    notifyListeners();

    final response = await _repository.getFavorites();

    response.fold(
      onSuccess: (products) async {
        _ids.clear();
        _idsSet.clear();

        _cache.clear();
        _favoriteIds.clear();
        for (final product in products) {
          _ids.add(product.id);
          _idsSet.add(product.id);

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
    if (!await _hasAuthenticatedSession()) {
      return;
    }
    // ===== حذف من المفضلة =====
    if (_busy) return;

    _busy = true;
    if (_idsSet.contains(productId)) {
      final favoriteId = _favoriteIds[productId];

      _ids.remove(productId);
      _idsSet.remove(productId);

      _cache.remove(productId);

      notifyListeners();

      await _saveFavorites();

      if (favoriteId != null) {
        final response = await _repository.removeFavorite(
          favoriteId: favoriteId,
        );

        if (response.isSuccess) {
          await loadFromServer();
        } else {
          _ids.remove(productId);
          _idsSet.remove(productId);
          _cache.remove(productId);

          await _saveFavorites();

          notifyListeners();
        }
      }
      _busy = false;
      return;
    }

    // ===== إضافة للمفضلة =====

    _ids.add(productId);
    _idsSet.add(productId);

    notifyListeners();

    await _loadProduct(productId);

    final response = await _repository.addFavorite(productId: productId);

    if (response.isSuccess) {
      await loadFromServer();
    } else {
      await loadFromServer();
    }
    _busy = false;
  }

  Future<void> _loadProduct(String id) async {
    final response = await _productRepository.getProductById(id);

    if (response.isSuccess && response.data != null) {
      _cache[id] = response.data!;

      await _saveFavorites();

      notifyListeners();
    }
  }
}
