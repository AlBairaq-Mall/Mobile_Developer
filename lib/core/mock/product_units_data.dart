import '../../features/products/models/product_unit_model.dart';

final productUnits = [
  ProductUnitModel(
    id: '1',
    itemCode: '1001',
    unitName: 'حبة',
    price: 500,
    package: '1 × 330ml',
    description: 'كوكاكولا حبة',
    unit: 'حبة',
    isDefault: true,
  ),

  ProductUnitModel(
    id: '2',
    itemCode: '1001',
    unitName: 'شدة',
    price: 9500,
    package: '24 حبة',
    description: 'كوكاكولا شدة',
    unit: 'شدة',
    isDefault: false,
  ),

  ProductUnitModel(
    id: '3',
    itemCode: '1001',
    unitName: 'كرتون',
    price: 18000,
    package: '48 حبة',
    description: 'كوكاكولا كرتون',
    unit: 'كرتون',
    isDefault: false,
  ),

  ProductUnitModel(
    id: '4',
    itemCode: '1002',
    unitName: 'حبة',
    price: 500,
    package: '1 × 330ml',
    description: 'بيبسي حبة',
    unit: 'حبة',
    isDefault: true,
  ),

  ProductUnitModel(
    id: '5',
    itemCode: '1002',
    unitName: 'شدة',
    price: 9400,
    package: '24 حبة',
    description: 'بيبسي شدة',
    unit: 'شدة',
    isDefault: false,
  ),
];
