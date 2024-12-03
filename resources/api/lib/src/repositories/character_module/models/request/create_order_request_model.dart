// ignore_for_file: avoid_dynamic_calls

import 'package:api/api.dart';

class CreateOrderRequestModel extends IBaseModel<CreateOrderRequestModel> {
  CreateOrderRequestModel({
    this.cariHesapId,
    this.orderDetails,
    this.description,
  });

  String? cariHesapId;
  String? description;
  List<OrderDetail>? orderDetails;

  @override
  CreateOrderRequestModel fromJson(Map<String, dynamic> json) =>
      CreateOrderRequestModel(
        cariHesapId: json['cariHesapId'],
        orderDetails: json['orderDetails'] == null
            ? []
            : List<OrderDetail>.from(
                json['orderDetails']!.map(OrderDetail.fromJson),
              ),
        description: json['aciklama'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'cariHesapId': cariHesapId,
        'orderDetails': orderDetails == null
            ? <dynamic>[]
            : List<dynamic>.from(orderDetails!.map((x) => x.toJson())),
        'aciklama': description,
      };
}

class OrderDetail {
  OrderDetail({
    this.productId,
    this.amount,
    this.unitPrice,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
        productId: json['productId'],
        amount: json['amount'],
        unitPrice: json['unitPrice'],
      );
  String? productId;
  String? amount;
  String? unitPrice;

  Map<String, dynamic> toJson() => {
        'productId': productId,
        'amount': amount,
        'unitPrice': unitPrice,
      };
}
