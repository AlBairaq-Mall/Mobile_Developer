import '../../../../core/api/api_endpoints.dart';
import '../../../../core/datasource/base_remote_datasource.dart';
import '../../../../core/network/api_response.dart';
import '../../../../core/utils/json_parser.dart';
import '../../models/address_model.dart';

class AddressRemoteDataSource extends BaseRemoteDataSource {
  AddressRemoteDataSource(super.dio);

  Future<ApiResponse<List<AddressModel>>> getLocations() =>
      getPaginated<List<AddressModel>>(
        ApiEndpoints.locations,
        parser: (json) => JsonParser.list(
          json,
          AddressModel.fromJson,
        ),
      );

  Future<ApiResponse<AddressModel>> createLocation({
    required String title,
    required String address,
    double? latitude,
    double? longitude,
    bool isDefault = false,
  }) =>
      postEnvelope<AddressModel>(
        ApiEndpoints.locations,
        data: {
          "title": title,
          "address": address,
          "latitude": latitude,
          "longitude": longitude,
          "is_default": isDefault,
        },
        parser: (json) => AddressModel.fromJson(
          JsonParser.map(json),
        ),
      );

  Future<ApiResponse<AddressModel>> updateLocation({
    required int id,
    required String title,
    required String address,
    double? latitude,
    double? longitude,
    bool isDefault = false,
  }) =>
      putEnvelope<AddressModel>(
        "${ApiEndpoints.locations}/$id",
        data: {
          "title": title,
          "address": address,
          "latitude": latitude,
          "longitude": longitude,
          "is_default": isDefault,
        },
        parser: (json) => AddressModel.fromJson(
          JsonParser.map(json),
        ),
      );

  Future<ApiResponse<void>> deleteLocation(int id) =>
      deleteEnvelope("${ApiEndpoints.locations}/$id");
}
