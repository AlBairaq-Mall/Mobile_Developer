import 'package:bhm_supermarket/core/network/dio_exception_mapper.dart';
import 'package:dio/dio.dart';

import '../../../../core/api/api_endpoints.dart';
import '../../../../core/datasource/base_remote_datasource.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/utils/json_parser.dart';
import '../../models/delivery_order_model.dart';

class DeliveryRemoteDataSource extends BaseRemoteDataSource {
  DeliveryRemoteDataSource(super.dio);

  Future<ApiResponse<List<DeliveryOrderModel>>> fetchOrders() {
    return getPaginated<List<DeliveryOrderModel>>(
      ApiEndpoints.deliveryOrders,
      parser: (json) => JsonParser.list(json, DeliveryOrderModel.fromJson),
    );
  }

  Future<ApiResponse<DeliveryOrderModel>> fetchOrderById(String id) {
    return getEnvelope<DeliveryOrderModel>(
      ApiEndpoints.deliveryOrder(id),
      parser: (json) => DeliveryOrderModel.fromJson(
        json is Map ? Map<String, dynamic>.from(json) : <String, dynamic>{},
      ),
    );
  }

  /// PATCH /api/delivery/orders/{id}/status
  @override
  Future<ApiResponse<void>> patchVoid(String path, {dynamic data}) async {
    try {
      final response = await dio.patch(path, data: data);

      final map = JsonParser.map(response.data);

      final success = JsonParser.boolValue(map['success'], fallback: true);

      final message = JsonParser.string(map['message']);

      if (!success) {
        return ApiResponse<void>.failure(
          message,
          statusCode: response.statusCode,
        );
      }

      return ApiResponse<void>.success(
        null,
        message: message,
        statusCode: response.statusCode,
      );
    } on DioException catch (error) {
      return apiResponseFromDioError(error);
    } catch (_) {
      return ApiResponse<void>.failure('حدث خطأ غير متوقع');
    }
  }

  Future<ApiResponse<void>> updateOrderStatus({
    required String orderId,
    required String status,
    String? paymentStatus,
  }) {
    final data = <String, dynamic>{'status': status};

    if (paymentStatus != null) {
      data['payment_status'] = paymentStatus;
    }

    return patchVoid(ApiEndpoints.deliveryOrderStatus(orderId), data: data);
  }

  /// PATCH /api/orders/{id}/delivery-driver
  Future<ApiResponse<void>> assignDriver({
    required String orderId,
    required int deliveryDriverId,
  }) async {
    try {
      final response = await dio.patch(
        ApiEndpoints.assignDeliveryDriver(orderId),
        data: {'delivery_driver_id': deliveryDriverId},
      );

      final body = response.data;

      if (body is Map<String, dynamic>) {
        final success = body['success'];

        if (success == false) {
          return ApiResponse<void>.failure(
            body['message']?.toString() ?? 'فشل تعيين عامل التوصيل',
            statusCode: response.statusCode,
          );
        }

        return ApiResponse<void>.success(
          null,
          message: body['message']?.toString() ?? '',
          statusCode: response.statusCode,
        );
      }

      return ApiResponse<void>.success(null, statusCode: response.statusCode);
    } on DioException catch (e) {
      return ApiResponse<void>.failure(
        e.response?.data is Map
            ? e.response?.data['message']?.toString() ??
                'حدث خطأ أثناء تعيين عامل التوصيل'
            : 'حدث خطأ أثناء تعيين عامل التوصيل',
        statusCode: e.response?.statusCode,
      );
    } catch (_) {
      return ApiResponse<void>.failure('حدث خطأ أثناء تعيين عامل التوصيل');
    }
  }
}
