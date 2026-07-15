import '../../../core/utils/json_parser.dart';

class CategoryModel {
  final String id;
  final String name;
  final String image;
  final String? parentId;
  final int sortOrder;

  const CategoryModel({
    required this.id,
    required this.name,
    required this.image,
    this.parentId,
    required this.sortOrder,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> json) => CategoryModel(
        id: JsonParser.string(json['id']),
        name: JsonParser.string(json['name']),
        image: JsonParser.string(json['image']),
        parentId: json['parent_id']?.toString(),
        sortOrder: JsonParser.intValue(json['sort_order']),
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'image': image,
        'parent_id': parentId,
        'sort_order': sortOrder,
      };
}
