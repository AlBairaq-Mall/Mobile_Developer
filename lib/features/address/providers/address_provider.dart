import 'package:flutter/material.dart';

import '../models/address_model.dart';

class AddressProvider extends ChangeNotifier {
  final List<AddressModel> _addresses = [
    const AddressModel(
      id: '1',
      title: 'المنزل',
      city: 'عدن',
      district: 'المنصورة',
      street: 'شارع السجن',
      phone: '775612613',
      isDefault: true,
    ),
  ];

  List<AddressModel> get addresses => _addresses;

  AddressModel? get selectedAddress {
    try {
      return _addresses.firstWhere((e) => e.isDefault);
    } catch (_) {
      return _addresses.isNotEmpty ? _addresses.first : null;
    }
  }

  void addAddress(AddressModel address) {
    // إذا كان العنوان الجديد افتراضياً، أزل الافتراضي من الباقين
    if (address.isDefault) {
      _clearDefault();
    }
    _addresses.add(address);
    notifyListeners();
  }

  void editAddress(String id, AddressModel updated) {
    final index = _addresses.indexWhere((a) => a.id == id);
    if (index == -1) return;
    if (updated.isDefault) _clearDefault();
    _addresses[index] = updated;
    notifyListeners();
  }

  void deleteAddress(String id) {
    _addresses.removeWhere((a) => a.id == id);
    // إذا لم يعد هناك عنوان افتراضي اجعل الأول هو الافتراضي
    if (_addresses.isNotEmpty && !_addresses.any((a) => a.isDefault)) {
      final first = _addresses.first;
      _addresses[0] = AddressModel(
        id: first.id,
        title: first.title,
        city: first.city,
        district: first.district,
        street: first.street,
        phone: first.phone,
        isDefault: true,
      );
    }
    notifyListeners();
  }

  void setDefault(String id) {
    _clearDefault();
    final index = _addresses.indexWhere((a) => a.id == id);
    if (index == -1) return;
    final a = _addresses[index];
    _addresses[index] = AddressModel(
      id: a.id,
      title: a.title,
      city: a.city,
      district: a.district,
      street: a.street,
      phone: a.phone,
      isDefault: true,
    );
    notifyListeners();
  }

  void _clearDefault() {
    for (var i = 0; i < _addresses.length; i++) {
      final a = _addresses[i];
      if (a.isDefault) {
        _addresses[i] = AddressModel(
          id: a.id,
          title: a.title,
          city: a.city,
          district: a.district,
          street: a.street,
          phone: a.phone,
          isDefault: false,
        );
      }
    }
  }
}

