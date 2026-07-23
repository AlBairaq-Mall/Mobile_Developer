import 'package:flutter/material.dart';

import '../../../app/di/dependency_injection.dart';
import '../models/order_model.dart';

class OrdersProvider extends ChangeNotifier {
  final _repository = DependencyInjection.orderRepository;

  List<OrderModel> _orders = [];

  bool _loading = false;

  List<OrderModel> get orders => _orders;

  bool get loading => _loading;

  Future<void> loadOrders() async {
    _loading = true;
    notifyListeners();

    final response = await _repository.getOrders();

    if (response.isSuccess && response.data != null) {
      _orders = response.data!;
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> refresh() async {
    await loadOrders();
  }
}
