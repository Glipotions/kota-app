import 'package:api/src/service/client/model/base/base_parse_model.dart';

class ProductCategoryModel extends IBaseModel<ProductCategoryModel> {
  ProductCategoryModel({
    this.code,
    this.name,
    this.pictureUrl,
    this.productCategoryType,
    this.productCount,
  });
  
  String? code;
  String? name;
  String? pictureUrl;
  int? productCategoryType;
  int? productCount;

  @override
  ProductCategoryModel fromJson(Map<String, dynamic> json) =>
      ProductCategoryModel(
        code: json['kod'],
        name: json['name'],
        pictureUrl: json['pictureUrl'],
        productCategoryType: json['productCategoryType'],
      );

  @override
  Map<String, dynamic> toJson() {
    throw UnimplementedError();
  }
}
