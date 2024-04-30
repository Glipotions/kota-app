// ignore_for_file: avoid_dynamic_calls, inference_failure_on_untyped_parameter

import 'package:api/api.dart';

class ProductGroupListResponseModel
    extends IBaseModel<ProductGroupListResponseModel> {
  ProductGroupListResponseModel({
    this.items,
    this.index,
    this.size,
    this.count,
    this.pages,
    this.hasPrevious,
    this.hasNext,
  });
  List<ProductGroupItem>? items;
  int? index;
  int? size;
  int? count;
  int? pages;
  bool? hasPrevious;
  bool? hasNext;

  @override
  ProductGroupListResponseModel fromJson(Map<String, dynamic> json) =>
      ProductGroupListResponseModel(
        items: json['items'] == null
            ? []
            : List<ProductGroupItem>.from(
                json['items']!.map((x) => ProductGroupItem().fromJson(x)),
              ),
        index: json['index'],
        size: json['size'],
        count: json['count'],
        pages: json['pages'],
        hasPrevious: json['hasPrevious'],
        hasNext: json['hasNext'],
      );

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}

class ProductGroupItem extends IBaseModel<ProductGroupItem> {
  ProductGroupItem({
    this.id,
    this.code,
    this.name,
    this.price,
    this.pictureUrl,
  });
  int? id;
  String? code;
  String? name;
  double? price;
  String? pictureUrl;

  @override
  ProductGroupItem fromJson(Map<String, dynamic> json) => ProductGroupItem(
        id: json['id'],
        code: json['code'],
        name: json['name'],
        pictureUrl: json['pictureUrl'],
        price: json['price']?.toDouble(),
      );

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}
