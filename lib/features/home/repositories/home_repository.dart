import '../../../core/models/product_model.dart';
import '../../products/domain/repositories/product_repository.dart';

class HomeRepository {
  final ProductRepository productRepository;

  HomeRepository(this.productRepository);

  Future<List<ProductModel>> getProducts({
    String? search,
    String? categoryId,
  }) async {
    try {
      final response = await productRepository.getProducts(
        search: search,
        categoryId: categoryId,
      );

      if (!response.isSuccess) {
        return [];
      }

      return response.data ?? [];
    } catch (_) {
      return [];
    }
  }
}
