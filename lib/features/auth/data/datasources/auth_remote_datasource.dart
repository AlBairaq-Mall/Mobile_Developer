import 'package:bhm_supermarket/core/network/dio_exception_mapper.dart';
import 'package:bhm_supermarket/core/services/secure_storage_service.dart';
import 'package:dio/dio.dart';

import '../../../../core/api/api_endpoints.dart';
import '../../../../core/datasource/base_remote_datasource.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/utils/json_parser.dart';
import '../../models/user_model.dart';

class AuthRemoteDataSource extends BaseRemoteDataSource {
  AuthRemoteDataSource(super.dio);

  // OTP DELIVERY CONFIGURATION
  // ---------------------------------------------------------
  // By default, OTP is sent via EMAIL (Laravel sends to user's email).
  //
  // To switch to SMS/PHONE OTP in the future:
  //   1. Change [otpChannel] below to OtpDeliveryChannel.sms
  //   2. In [sendOtp], use the SMS payload instead of email payload.
  //   3. In [verifyOtp], send `phone` instead of `email` in request body.
  //   4. Update LoginScreen to collect phone number (not just email).
  // ---------------------------------------------------------
  // ── SMS OTP verify (future) ─────────────────────────────────────────────
  // payload = {
  //   'phone': phone,
  //   'otp': otp,
  //   'method': 'sms',
  //   if (name != null) 'name': name,
  //   if (email != null) 'email': email,
  // };
  Future<ApiResponse<UserModel>> register({
    required String name,
    required String phone,
    required String email,
    required String password,
    required String passwordConfirmation,
  }) async {
    try {
      final response = await dio.post(ApiEndpoints.authRegister, data: {
        'name': name,
        'phone': phone,
        'email': email,
        'password': password,
        'password_confirmation': passwordConfirmation,
      });

      final user = UserModel.fromJson({
        ...response.data["user"],
        "token": null,
      });

      return ApiResponse.success(
        user,
        message: response.data["message"] ?? "",
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return apiResponseFromDioError(e);
    }
  }

  Future<ApiResponse<UserModel>> login({
    required String email,
    required String password,
  }) async {
    try {
      final response = await dio.post(
        ApiEndpoints.authLogin,
        data: {"email": email, "password": password},
      );

      return ApiResponse.success(
        _parseLogin(response.data),
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return apiResponseFromDioError(e);
    }
  }

  UserModel _parseLogin(dynamic json) {
    final map = JsonParser.map(json);

    final user = JsonParser.map(map["user"]);

    final token = JsonParser.map(map["token"]);

    final original = JsonParser.map(token["original"]);

    return UserModel(
      id: user["id"].toString(),
      name: user["name"] ?? "",
      email: user["email"] ?? "",
      phone: user["phone"] ?? "",
      role: UserRole.values.firstWhere(
        (e) => e.name == (user["role"] ?? "customer"),
        orElse: () => UserRole.customer,
      ),
      token: original["access_token"],
    );
  }

  Future<ApiResponse<void>> logout() async {
    try {
      final response = await dio.post(ApiEndpoints.authLogout);

      return ApiResponse.success(
        null,
        message: response.data["message"] ?? "",
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return apiResponseFromDioError(e);
    }
  }

  // UserModel _parseAuthUser(dynamic json) {
  //   final map = JsonParser.map(json);

  //   final user = JsonParser.map(map['user']);

  //   final token = JsonParser.map(map['token']);

  //   final original = JsonParser.map(token['original']);

  //   return UserModel(
  //     id: user['id'].toString(),
  //     name: user['name'] ?? '',
  //     email: user['email'] ?? '',
  //     phone: user['phone'] ?? '',
  //     role: UserRole.values.firstWhere(
  //       (e) => e.name == (user['role'] ?? 'customer'),
  //       orElse: () => UserRole.customer,
  //     ),
  //     token: original['access_token'],
  //   );
  // }

  Future<ApiResponse<UserModel>> me() async {
    try {
      final response = await dio.post(ApiEndpoints.me);

      final stored = await SecureStorageService.instance.readToken();

      return ApiResponse.success(
        UserModel.fromJson({
          ...Map<String, dynamic>.from(response.data),
          "token": stored,
        }),
        statusCode: response.statusCode,
      );
    } on DioException catch (e) {
      return apiResponseFromDioError(e);
    }
  }
  // UserModel _parseAuthUser(dynamic json) {
  //   final map = JsonParser.map(json);
  //   if (map.containsKey('user')) {
  //     final user = UserModel.fromJson(JsonParser.map(map['user']));
  //     final token = map['token']?.toString();
  //     return UserModel(
  //       id: user.id,
  //       name: user.name,
  //       phone: user.phone,
  //       email: user.email,
  //       role: user.role,
  //       token: token ?? user.token,
  //     );
  //   }
  //   return UserModel.fromJson(map);
  // }
}
