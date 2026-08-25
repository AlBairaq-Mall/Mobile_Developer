import 'package:flutter/material.dart';

import '../domain/repositories/order_repository.dart';
import '../models/order_model.dart';
import 'package:bhm_supermarket/core/services/secure_storage_service.dart';

class OrdersProvider extends ChangeNotifier {
  OrdersProvider(this._repository);

  final OrderRepository _repository;

  final List<OrderModel> _orders = [];
  List<OrderModel> get orders => _orders;

  bool _loading = false;
  bool get loading => _loading;

  bool _loadingMore = false;
  bool get loadingMore => _loadingMore;

  String? _error;
  String? get error => _error;

  int _currentPage = 1;
  bool _hasMore = true;
  bool get hasMore => _hasMore;

  Future<void> loadOrders({bool refresh = false}) async {
    if (_loading) return;

    final token = await SecureStorageService.instance.readToken();
    if (token == null || token.isEmpty) return;

    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _repository.getOrders(page: 1);

      if (response.isSuccess && response.data != null) {
        _orders.clear();
        _orders.addAll(response.data!.items);
        _hasMore = response.data!.meta.hasNext;
        _currentPage = _hasMore ? 2 : 1;
        _error = null;
      } else {
        _error = response.message;
      }
    } catch (e) {
      _error = 'حدث خطأ غير متوقع';
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> loadMore() async {
    if (!_hasMore || _loading || _loadingMore) return;

    final token = await SecureStorageService.instance.readToken();
    if (token == null || token.isEmpty) return;

    _loadingMore = true;
    notifyListeners();

    try {
      final response = await _repository.getOrders(page: _currentPage);

      if (response.isSuccess && response.data != null) {
        final newOrders = response.data!.items;

        final existingIds = _orders.map((e) => e.id).toSet();
        for (final order in newOrders) {
          if (!existingIds.contains(order.id)) {
            _orders.add(order);
          }
        }

        _hasMore = response.data!.meta.hasNext;
        if (_hasMore) {
          _currentPage++;
        }
      }
    } catch (e) {
      // Silently fail loadMore or handle appropriately
    } finally {
      _loadingMore = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await loadOrders(refresh: true);
  }
}
