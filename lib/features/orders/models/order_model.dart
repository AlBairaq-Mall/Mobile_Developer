import '../../../core/utils/json_parser.dart';

class OrderModel {
  final String id;
  final String number;
  final String status;
  final String date;
  final double total;
  final int itemCount;

  const OrderModel({
    required this.id,
    required this.number,
    required this.status,
    required this.date,
    required this.total,
    required this.itemCount,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) => OrderModel(
        id: JsonParser.string(json['id']),
        number: JsonParser.string(json['order_number'] ?? json['number']),
        status: JsonParser.string(json['status']),
        date: JsonParser.string(json['date'] ?? json['created_at']),
        total: JsonParser.doubleValue(json['total']),
        itemCount: JsonParser.intValue(json['item_count'] ?? json['items_count']),
      );
}
