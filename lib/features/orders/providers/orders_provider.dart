import 'package:flutter/material.dart';

import '../domain/repositories/order_repository.dart';
import '../models/order_model.dart';
import 'package:bhm_supermarket/core/services/secure_storage_service.dart';

class OrdersProvider extends ChangeNotifier {
  OrdersProvider(this._repository);

  final OrderRepository _repository;

  List<OrderModel> _orders = [];

  bool _loading = false;

  List<OrderModel> get orders => _orders;

  bool get loading => _loading;

  Future<void> loadOrders() async {
    final token = await SecureStorageService.instance.readToken();

    if (token == null || token.isEmpty) {
      return;
    }

    if (_loading) return;

    _loading = true;
    notifyListeners();

    try {
      final response = await _repository.getOrders();

      if (response.isSuccess && response.data != null) {
        _orders = response.data!;
      }
    } finally {
      _loading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await loadOrders();
  }
}
