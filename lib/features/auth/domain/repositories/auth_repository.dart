import '../../../../core/network/api_response.dart';
import '../../models/user_model.dart';
import '../../models/login_flow_model.dart';

abstract class AuthRepository {
  Future<ApiResponse<UserModel>> register({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String passwordConfirmation,
  });

  Future<ApiResponse<UserModel>> login({
    required String email,
    required String password,
  });

  Future<ApiResponse<void>> logout();

  Future<UserModel?> loadStoredUser();
}
