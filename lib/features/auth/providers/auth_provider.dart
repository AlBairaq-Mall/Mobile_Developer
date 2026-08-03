import 'package:bhm_supermarket/app/router/app_routes.dart';
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
  String consumePendingRedirect() {
    final path = _pendingRedirect;
    _pendingRedirect = null;
    return path ?? AppRoutes.home;
  }

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

  Future<String?> login({
    required String email,
    required String password,
  }) async {
    _setLoading(true);

    final response = await _repository.login(
      email: email,
      password: password,
    );

    _setLoading(false);

    if (response.isSuccess && response.data != null) {
      _user = response.data;
      notifyListeners();
      return null;
    }

    return response.message;
  }

  Future<String?> register({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    _setLoading(true);

    final response = await _repository.register(
      name: name,
      phone: phone,
      email: email,
      password: password,
      passwordConfirmation: passwordConfirmation,
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
