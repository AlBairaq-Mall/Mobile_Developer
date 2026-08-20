import 'package:flutter/foundation.dart';
import '../../delivery/models/delivery_order_model.dart';
import '../../delivery/domain/repositories/delivery_repository.dart';
import '../domain/repositories/admin_orders_repository.dart';

class AdminOrdersProvider extends ChangeNotifier {
  final AdminOrdersRepository _repository;
  final DeliveryRepository _deliveryRepository;

  AdminOrdersProvider(this._repository, this._deliveryRepository);

  List<DeliveryOrderModel> _orders = [];
  List<DeliveryOrderModel> get orders => _orders;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  bool _isAssigning = false;
  bool get isAssigning => _isAssigning;

  Future<void> loadOrders() async {
    _loading = true;
    _error = null;
    notifyListeners();

    final response = await _repository.getOrders();

    if (response.isSuccess) {
      _orders = response.data ?? [];
      _error = null;
    } else {
      _error = response.message;
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> refresh() => loadOrders();

  Future<String?> assignDriver(String orderId, int driverId) async {
    if (_isAssigning) return 'يوجد عملية تعيين قيد التنفيذ';

    _isAssigning = true;
    notifyListeners();

    final response = await _deliveryRepository.assignDriver(
      orderId: orderId,
      deliveryDriverId: driverId,
    );

    _isAssigning = false;

    if (!response.isSuccess) {
      notifyListeners();
      return response.message;
    }

    // Refresh orders to get the updated driver info (or we can update it locally, but the API didn't return the driver object, so we refresh)
    await loadOrders();
    return null;
  }
}
