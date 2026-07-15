import '../../../../core/network/api_response.dart';
import '../../models/user_model.dart';

abstract class AuthRepository {
  Future<ApiResponse<void>> sendOtp({required String email});

  Future<ApiResponse<UserModel>> verifyOtp({
    required String email,
    required String otp,
    String? name,
    String? phone,
  });

  Future<ApiResponse<UserModel>> register({
    required String name,
    required String phone,
    required String email,
  });

  Future<ApiResponse<UserModel>> loginWithPassword({
    required String email,
    required String password,
    required UserRole expectedRole,
  });

  Future<ApiResponse<void>> logout();

  Future<UserModel?> loadStoredUser();
}
