import '../../../../core/network/api_response.dart';
import '../../../auth/models/user_model.dart';
import '../../domain/repositories/admin_user_repository.dart';
import '../datasources/admin_user_remote_datasource.dart';

class AdminUserRepositoryImpl implements AdminUserRepository {
  final AdminUserRemoteDataSource _remote;
  AdminUserRepositoryImpl(this._remote);

  @override
  Future<ApiResponse<List<UserModel>>> getUsers() {
    return _remote.getUsers();
  }
}
