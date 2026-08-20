
import '../../../../core/api/api_endpoints.dart';
import '../../../../core/datasource/base_remote_datasource.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/utils/json_parser.dart';
import '../../../auth/models/user_model.dart';

class AdminUserRemoteDataSource extends BaseRemoteDataSource {
  AdminUserRemoteDataSource(super.dio);

  Future<ApiResponse<List<UserModel>>> getUsers() {
    return getPaginated<List<UserModel>>(
      ApiEndpoints.adminUsers,
      parser: (json) => JsonParser.list(
        json,
        UserModel.fromJson,
      ),
    );
  }
}
