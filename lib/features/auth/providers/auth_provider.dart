import 'package:flutter/material.dart';

import '../domain/repositories/auth_repository.dart';
import '../models/user_model.dart';

enum LoginMethod { email }

class AuthProvider extends ChangeNotifier {
  AuthProvider(this._repository);

  final AuthRepository _repository;

  UserModel? _user;
  bool _isLoading = false;
  String? _pendingRedirect;

  UserModel? get user => _user;
  bool get isLoading => _isLoading;
  bool get isLoggedIn => _user != null;
  bool get isAdmin => _user?.isAdmin ?? false;
  bool get isDelivery => _user?.isDelivery ?? false;
  String? get pendingRedirect => _pendingRedirect;

  /// Restore session from secure storage (non-blocking for guests).
  Future<void> initSession() async {
    _user = await _repository.loadStoredUser();
    notifyListeners();
  }

  void setPendingRedirect(String? path) {
    _pendingRedirect = path;
  }

  void clearPendingRedirect() {
    _pendingRedirect = null;
  }

  Future<String?> sendOtp({required String email}) async {
    _setLoading(true);
    final response = await _repository.sendOtp(email: email);
    _setLoading(false);
    return response.isSuccess ? null : response.message;
  }

  Future<String?> verifyOtp({
    required String email,
    required String otp,
    String? name,
    String? phone,
  }) async {
    _setLoading(true);
    final response = await _repository.verifyOtp(
      email: email,
      otp: otp,
      name: name,
      phone: phone,
    );
    _setLoading(false);
    if (response.isSuccess && response.data != null) {
      _user = response.data;
      notifyListeners();
      return null;
    }
    return response.message;
  }

  Future<String?> loginWithPassword({
    required String email,
    required String password,
    required UserRole expectedRole,
  }) async {
    _setLoading(true);
    final response = await _repository.loginWithPassword(
      email: email,
      password: password,
      expectedRole: expectedRole,
    );
    _setLoading(false);
    if (response.isSuccess && response.data != null) {
      _user = response.data;
      notifyListeners();
      return null;
    }
    return response.message;
  }

  Future<void> logout() async {
    await _repository.logout();
    _user = null;
    notifyListeners();
  }

  void _setLoading(bool value) {
    _isLoading = value;
    notifyListeners();
  }
}
