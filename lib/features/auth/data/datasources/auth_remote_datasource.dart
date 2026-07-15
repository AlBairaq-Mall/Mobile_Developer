import '../../../../core/api/api_endpoints.dart';
import '../../../../core/datasource/base_remote_datasource.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/utils/json_parser.dart';
import '../../models/user_model.dart';

/// OTP delivery channel — **Email is active by default**.
enum OtpDeliveryChannel { email, sms }

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
  static const OtpDeliveryChannel otpChannel = OtpDeliveryChannel.email;

  Future<ApiResponse<void>> sendOtp({required String email, String? phone}) {
    final Map<String, dynamic> payload;

    if (otpChannel == OtpDeliveryChannel.email) {
      payload = {
        'email': email,
        'method': 'email',
      };
    } else {
      // ── SMS OTP (future) ──────────────────────────────────────────────────
      // payload = {
      //   'phone': phone ?? email,
      //   'method': 'sms',
      // };
      payload = {'email': email, 'method': 'email'};
    }

    return postEnvelope<void>(
      ApiEndpoints.authSendOtp,
      data: payload,
      parser: (_) => null,
    );
  }

  Future<ApiResponse<UserModel>> verifyOtp({
    required String email,
    required String otp,
    String? name,
    String? phone,
  }) {
    final Map<String, dynamic> payload = {
      'otp': otp,
      if (otpChannel == OtpDeliveryChannel.email) 'email': email,
      if (otpChannel == OtpDeliveryChannel.email) 'method': 'email',
      if (name != null && name.isNotEmpty) 'name': name,
      if (phone != null && phone.isNotEmpty) 'phone': phone,
    };

    // ── SMS OTP verify (future) ─────────────────────────────────────────────
    // payload = {
    //   'phone': phone,
    //   'otp': otp,
    //   'method': 'sms',
    //   if (name != null) 'name': name,
    //   if (email != null) 'email': email,
    // };

    return postEnvelope<UserModel>(
      ApiEndpoints.authVerifyOtp,
      data: payload,
      parser: _parseAuthUser,
    );
  }

  Future<ApiResponse<UserModel>> register({
    required String name,
    required String phone,
    required String email,
  }) =>
      postEnvelope<UserModel>(
        ApiEndpoints.authRegister,
        data: {'name': name, 'phone': phone, 'email': email},
        parser: _parseAuthUser,
      );

  Future<ApiResponse<UserModel>> loginWithPassword({
    required String email,
    required String password,
  }) =>
      postEnvelope<UserModel>(
        ApiEndpoints.authLogin,
        data: {'email': email, 'password': password},
        parser: _parseAuthUser,
      );

  Future<ApiResponse<void>> logout() => deleteEnvelope(ApiEndpoints.authLogout);

  UserModel _parseAuthUser(dynamic json) {
    final map = JsonParser.map(json);
    if (map.containsKey('user')) {
      final user = UserModel.fromJson(JsonParser.map(map['user']));
      final token = map['token']?.toString();
      return UserModel(
        id: user.id,
        name: user.name,
        phone: user.phone,
        email: user.email,
        role: user.role,
        token: token ?? user.token,
      );
    }
    return UserModel.fromJson(map);
  }
}
