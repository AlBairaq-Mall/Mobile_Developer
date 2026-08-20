import 'package:flutter/foundation.dart';
import '../../auth/models/user_model.dart';
import '../domain/repositories/admin_user_repository.dart';

class AdminUsersProvider extends ChangeNotifier {
  final AdminUserRepository _repository;

  AdminUsersProvider(this._repository);

  List<UserModel> _users = [];
  List<UserModel> get users => _users;

  bool _loading = false;
  bool get loading => _loading;

  String? _error;
  String? get error => _error;

  String _selectedRoleFilter = 'الكل';
  String get selectedRoleFilter => _selectedRoleFilter;

  List<UserModel> get filteredUsers {
    if (_selectedRoleFilter == 'الكل') return _users;
    if (_selectedRoleFilter == 'عملاء') {
      return _users.where((u) => u.role == UserRole.customer).toList();
    }
    if (_selectedRoleFilter == 'سائقون') {
      return _users.where((u) => u.role == UserRole.delivery).toList();
    }
    if (_selectedRoleFilter == 'مديرون') {
      return _users.where((u) => u.role == UserRole.admin).toList();
    }
    return _users;
  }

  void setRoleFilter(String filter) {
    _selectedRoleFilter = filter;
    notifyListeners();
  }

  Future<void> loadUsers() async {
    _loading = true;
    _error = null;
    notifyListeners();

    final response = await _repository.getUsers();

    if (response.isSuccess) {
      _users = response.data ?? [];
      _error = null;
    } else {
      _error = response.message;
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> refresh() => loadUsers();
}
