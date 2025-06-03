// ignore_for_file: avoid_dynamic_calls

import 'package:api/api.dart';

class CreateOrderRequestModel extends IBaseModel<CreateOrderRequestModel> {
  CreateOrderRequestModel({
    this.id,
    this.cariHesapId,
    this.orderDetails,
    this.description,
    this.connectedBranchCurrentInfoId,
    this.currencyType,
    this.generalDiscountRate,
  });

  int? id;
  String? cariHesapId;
  String? description;
  List<OrderDetail>? orderDetails;
  int? connectedBranchCurrentInfoId;
  int? currencyType;
  double? generalDiscountRate;

  @override
  CreateOrderRequestModel fromJson(Map<String, dynamic> json) =>
      CreateOrderRequestModel(
        id: json['id'],
        cariHesapId: json['cariHesapId'],
        orderDetails: json['orderDetails'] == null
            ? []
            : List<OrderDetail>.from(
                json['orderDetails']!.map(OrderDetail.fromJson),
              ),
        description: json['aciklama'],
        connectedBranchCurrentInfoId:
            json['connectedBranchCurrentInfoId'],
        currencyType: json['currencyType'],
        generalDiscountRate: json['generalDiscountRate']?.toDouble(),
      );

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'cariHesapId': cariHesapId,
        'orderDetails': orderDetails == null
            ? <dynamic>[]
            : List<dynamic>.from(orderDetails!.map((x) => x.toJson())),
        'aciklama': description,
        'connectedBranchCurrentInfoId': connectedBranchCurrentInfoId,
        'currencyType': currencyType,
        'generalDiscountRate': generalDiscountRate,
      };
}

class OrderDetail {
  OrderDetail({
    this.id,
    this.productId,
    this.amount,
    this.unitPrice,
    this.currencyUnitPrice,
    this.discountRate,
  });

  factory OrderDetail.fromJson(Map<String, dynamic> json) => OrderDetail(
        id: json['id'],
        productId: json['productId'],
        amount: json['amount'],
        unitPrice: json['unitPrice'],
        currencyUnitPrice: json['currencyUnitPrice'],
        discountRate: json['discountRate']?.toDouble(),
      );

  int? id;
  String? productId;
  String? amount;
  String? unitPrice;
  String? currencyUnitPrice;
  double? discountRate;

  Map<String, dynamic> toJson() => {
        'id': id ?? 0,
        'productId': productId,
        'amount': amount,
        'unitPrice': unitPrice,
        'currencyUnitPrice': currencyUnitPrice,
        'discountRate': discountRate,
      };
}
