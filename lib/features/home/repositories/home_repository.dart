import '../../../core/mock/product_units_data.dart' as data;
import '../../../core/models/product_model.dart';

import '../datasource/home_remote_datasource.dart';

class HomeRepository {
  final HomeRemoteDatasource datasource;

  HomeRepository(this.datasource);

  Future<List<ProductModel>> getProducts() async {
    try {
      // مستقبلاً
      // final json = await datasource.getProducts();
      // return ProductMapper.fromList(json);

      return List.from(data.productUnits);
    } catch (_) {
      return List.from(data.productUnits);
    }
  }
}
