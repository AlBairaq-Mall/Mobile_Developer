import 'package:flutter/material.dart';

import '../../../app/di/dependency_injection.dart';
import '../models/address_model.dart';

class AddressProvider extends ChangeNotifier {
  final _repository = DependencyInjection.addressRepository;

  List<AddressModel> _addresses = [];

  bool _loading = false;

  bool get loading => _loading;

  List<AddressModel> get addresses => _addresses;

  AddressModel? get selectedAddress {
    if (_addresses.isEmpty) return null;

    for (final e in _addresses) {
      if (e.isDefault) {
        return e;
      }
    }

    return _addresses.first;
  }

  Future<void> loadAddresses() async {
    if (_loading) return;

    _loading = true;
    notifyListeners();

    final response = await _repository.getLocations();

    if (response.isSuccess && response.data != null) {
      _addresses = response.data!;
    }

    _loading = false;
    notifyListeners();
  }

  Future<bool> addAddress({
    required String title,
    required String address,
    double? latitude,
    double? longitude,
    bool isDefault = false,
  }) async {
    final response = await _repository.createLocation(
      title: title,
      address: address,
      latitude: latitude,
      longitude: longitude,
      isDefault: isDefault,
    );

    if (!response.isSuccess) {
      return false;
    }

    await loadAddresses();

    notifyListeners();

    return true;
  }

  Future<bool> editAddress({
    required int id,
    required String title,
    required String address,
    double? latitude,
    double? longitude,
    bool isDefault = false,
  }) async {
    final response = await _repository.updateLocation(
      id: id,
      title: title,
      address: address,
      latitude: latitude,
      longitude: longitude,
      isDefault: isDefault,
    );

    if (!response.isSuccess) {
      return false;
    }

    await loadAddresses();

    notifyListeners();

    return true;
  }

  Future<bool> deleteAddress(int id) async {
    final response = await _repository.deleteLocation(id);

    if (!response.isSuccess) {
      return false;
    }

    await loadAddresses();

    notifyListeners();

    return true;
  }

  Future<bool> setDefault(String id) async {
    final address = _addresses.firstWhere(
      (e) => e.id == id,
    );

    final response = await _repository.updateLocation(
      id: int.parse(id),
      title: address.title,
      address: address.address,
      latitude: address.latitude,
      longitude: address.longitude,
      isDefault: true,
    );

    if (!response.isSuccess) {
      return false;
    }

    await loadAddresses();

    notifyListeners();

    return true;
  }
}
