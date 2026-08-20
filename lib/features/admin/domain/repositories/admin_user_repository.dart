import '../../../../core/network/api_response.dart';
import '../../../auth/models/user_model.dart';

abstract class AdminUserRepository {
  Future<ApiResponse<List<UserModel>>> getUsers();
}
