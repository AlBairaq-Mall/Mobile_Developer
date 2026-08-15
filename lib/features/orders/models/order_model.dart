import '../../../core/utils/json_parser.dart';
import '../../address/models/address_model.dart';
import 'order_item_model.dart';

class OrderModel {
  final String id;
  final String orderNumber;

  final AddressModel location;

  final List<OrderItemModel> items;

  final double subtotal;
  final double deliveryFee;
  final double discount;
  final double total;

  final String paymentMethod;
  final String paymentStatus;
  final String status;

  final String? notes;

  final String createdAt;

  final double couponDiscount;

  const OrderModel({
    required this.id,
    required this.orderNumber,
    required this.location,
    required this.items,
    required this.subtotal,
    required this.deliveryFee,
    required this.discount,
    required this.total,
    required this.paymentMethod,
    required this.paymentStatus,
    required this.status,
    this.notes,
    required this.createdAt,
    required this.couponDiscount,
  });

  factory OrderModel.fromJson(Map<String, dynamic> json) {
    final backendDiscount = JsonParser.doubleValue(json["discount"]);

    final couponDiscount = JsonParser.doubleValue(json["coupon_discount"]);

    return OrderModel(
      id: JsonParser.string(json["id"]),
      orderNumber: JsonParser.string(json["order_number"]),
      location: AddressModel.fromJson(JsonParser.map(json["location"])),
      items: JsonParser.list(json["items"], OrderItemModel.fromJson),
      subtotal: JsonParser.doubleValue(json["subtotal"]),
      deliveryFee: JsonParser.doubleValue(json["delivery_fee"]),

      // الخصم النهائي الذي نعرضه للعميل
      discount: couponDiscount > 0 ? couponDiscount : backendDiscount,

      couponDiscount: couponDiscount,

      total: JsonParser.doubleValue(json["total"]),
      paymentMethod: JsonParser.string(json["payment_method"]),
      paymentStatus: JsonParser.string(json["payment_status"]),
      status: JsonParser.string(json["status"]),
      notes: json["notes"]?.toString(),
      createdAt: JsonParser.string(json["created_at"]),
    );
  }

  // Map<String, dynamic> toJson() {
  //   return {
  //     "id": id,
  //     "order_number": orderNumber,
  //     "subtotal": subtotal,
  //     "delivery_fee": deliveryFee,
  //     "discount": discount,
  //     "total": total,
  //     "payment_method": paymentMethod,
  //     "payment_status": paymentStatus,
  //     "status": status,
  //     "notes": notes,
  //     "created_at": createdAt,
  //   };
  // }

  Map<String, dynamic> toJson() {
    return {
      "id": id,
      "order_number": orderNumber,
      "subtotal": subtotal,
      "delivery_fee": deliveryFee,
      "discount": discount,
      "coupon_discount": couponDiscount,
      "total": total,
      "payment_method": paymentMethod,
      "payment_status": paymentStatus,
      "status": status,
      "notes": notes,
      "created_at": createdAt,
    };
  }
}
