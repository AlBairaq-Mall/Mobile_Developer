import '../models/product_unit_model.dart';
import '../domain/repositories/product_repository.dart';

class ProductUnitsRepository {
  final ProductRepository productRepository;

  ProductUnitsRepository(this.productRepository);

  Future<List<ProductUnitModel>> getUnitsByProductId(String productId) async {
    try {
      final response = await productRepository.getProductById(productId);

      if (!response.isSuccess || response.data == null) {
        return [];
      }

      return response.data!.units;
    } catch (_) {
      return [];
    }
  }

  /// توافق مع الكود القديم.
  ///
  /// يبحث عن المنتج بواسطة unique_number / itemCode،
  /// ثم يعيد وحداته من ProductModel.
  Future<List<ProductUnitModel>> getUnitsByItemCode(String itemCode) async {
    try {
      final response = await productRepository.getProducts(search: itemCode);

      if (!response.isSuccess) {
        return [];
      }

      final products = response.data ?? [];

      for (final product in products) {
        if (product.itemCode == itemCode) {
          return product.units;
        }
      }

      return [];
    } catch (_) {
      return [];
    }
  }
}
