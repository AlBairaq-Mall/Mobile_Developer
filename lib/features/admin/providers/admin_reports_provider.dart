import 'package:flutter/foundation.dart';

import '../domain/repositories/admin_reports_repository.dart';
import '../models/admin_reports_model.dart';

class AdminReportsProvider extends ChangeNotifier {
  final AdminReportsRepository repository;

  AdminReportsProvider(this.repository);

  bool isLoading = false;
  String? error;

  SalesReport? sales;
  CustomersReport? customers;
  ProductsReport? products;
  OrdersReport? orders;
  LocationsReport? locations;

  List<DeliveryDriverReport> drivers = [];

  String? from;
  String? to;

  Future<void> loadReports({
    String? fromDate,
    String? toDate,
  }) async {
    from = fromDate;
    to = toDate;

    isLoading = true;
    error = null;
    notifyListeners();

    try {
      final results = await Future.wait([
        repository.getSales(
          from: from,
          to: to,
        ),
        repository.getCustomers(),
        repository.getProducts(),
        repository.getOrders(
          from: from,
          to: to,
        ),
        repository.getDeliveryDrivers(
          from: from,
          to: to,
        ),
        repository.getLocations(),
      ]);

      sales = results[0] as SalesReport;
      customers = results[1] as CustomersReport;
      products = results[2] as ProductsReport;
      orders = results[3] as OrdersReport;
      drivers = results[4] as List<DeliveryDriverReport>;
      locations = results[5] as LocationsReport;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<DeliveryDriverDetailsReport?> loadDriverDetails(
    int id,
  ) async {
    try {
      return await repository.getDeliveryDriver(
        id,
        from: from,
        to: to,
      );
    } catch (e) {
      error = e.toString();
      notifyListeners();
      return null;
    }
  }

  Future<void> refresh() {
    return loadReports(
      fromDate: from,
      toDate: to,
    );
  }
}
