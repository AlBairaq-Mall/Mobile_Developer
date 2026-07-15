import '../../../core/mock/product_units_data.dart';
import '../models/product_unit_model.dart';

class ProductUnitsRepository {
  List<ProductUnitModel> getUnitsByItemCode(String itemCode) {
    return productUnits.where((unit) => unit.itemCode == itemCode).toList();
  }
}
