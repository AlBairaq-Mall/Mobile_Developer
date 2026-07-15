import '../../../../core/network/api_response.dart';
import '../../../../core/services/secure_storage_service.dart';
import '../../domain/repositories/auth_repository.dart';
import '../../models/user_model.dart';
import '../datasources/auth_remote_datasource.dart';

class AuthRepositoryImpl implements AuthRepository {
  AuthRepositoryImpl(this._remote, this._storage);

  final AuthRemoteDataSource _remote;
  final SecureStorageService _storage;

  @override
  Future<ApiResponse<void>> sendOtp({required String email}) =>
      _remote.sendOtp(email: email);

  @override
  Future<ApiResponse<UserModel>> verifyOtp({
    required String email,
    required String otp,
    String? name,
    String? phone,
  }) async {
    final response = await _remote.verifyOtp(
      email: email,
      otp: otp,
      name: name,
      phone: phone,
    );
    if (response.isSuccess && response.data != null) {
      await _storage.saveUserProfile(response.data!);
    }
    return response;
  }

  @override
  Future<ApiResponse<UserModel>> register({
    required String name,
    required String phone,
    required String email,
  }) async {
    final response = await _remote.register(
      name: name,
      phone: phone,
      email: email,
    );
    if (response.isSuccess && response.data != null) {
      await _storage.saveUserProfile(response.data!);
    }
    return response;
  }

  @override
  Future<ApiResponse<UserModel>> loginWithPassword({
    required String email,
    required String password,
    required UserRole expectedRole,
  }) async {
    final response = await _remote.loginWithPassword(
      email: email,
      password: password,
    );
    if (response.isFailure || response.data == null) return response;

    final user = response.data!;
    if (user.role != expectedRole) {
      return ApiResponse.failure('بيانات الدخول غير صحيحة');
    }

    await _storage.saveUserProfile(user);
    return response;
  }

  @override
  Future<ApiResponse<void>> logout() async {
    final response = await _remote.logout();
    await _storage.clearAll();
    return response;
  }

  @override
  Future<UserModel?> loadStoredUser() => _storage.loadUserProfile();
}
