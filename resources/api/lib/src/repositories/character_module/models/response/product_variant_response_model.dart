// ignore: lines_longer_than_80_chars
// ignore_for_file: inference_failure_on_collection_literal, inference_failure_on_untyped_parameter, avoid_dynamic_calls, unnecessary_lambdas

import 'package:api/api.dart';

class ProductVariantResponseModel
    extends IBaseModel<ProductVariantResponseModel> {
  ProductVariantResponseModel({
    this.productVariants,
    this.sizes,
    this.colors,
    this.pictureUrl,
  });
  List<ProductVariant>? productVariants;
  List<String>? sizes;
  List<String>? colors;
  String? pictureUrl;

  @override
  ProductVariantResponseModel fromJson(Map<String, dynamic> json) =>
      ProductVariantResponseModel(
        productVariants: json['productVariants'] == null
            ? []
            : List<ProductVariant>.from(
                json['productVariants']!.map((x) => ProductVariant.fromJson(x)),
              ),
        sizes: json['sizes'] == null
            ? []
            : List<String>.from(json['sizes']!.map((x) => x)),
        colors: json['colors'] == null
            ? []
            : List<String>.from(json['colors']!.map((x) => x)),
            pictureUrl: json['pictureUrl'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'productVariants': productVariants == null
            ? []
            : List<dynamic>.from(productVariants!.map((x) => x.toJson())),
        'sizes': sizes == null ? [] : List<dynamic>.from(sizes!.map((x) => x)),
        'colors': colors == null
            ? []
            : List<dynamic>.from(
                colors!.map((x) => x),
              ),
        'pictureUrl':pictureUrl,
      };
}

class ProductVariant {
  ProductVariant({
    this.id,
    this.productId,
    this.productCode,
    this.productName,
    this.unitPrice,
    this.stock,
    this.productCodeGroupId,
    this.colorId,
    this.colorName,
    this.sizeId,
    this.sizeName,
    this.durum,
  });

  factory ProductVariant.fromJson(Map<String, dynamic> json) => ProductVariant(
        id: json['id'],
        productId: json['productId'],
        productCode: json['productCode'],
        productName: json['productName'],
        unitPrice: json['unitPrice'],
        stock: json['stock'],
        productCodeGroupId: json['productCodeGroupId'],
        colorId: json['colorId'],
        colorName: json['colorName'],
        sizeId: json['sizeId'],
        sizeName: json['sizeName'],
        durum: json['durum'],
      );

  int? id;
  int? productId;
  String? productCode;
  String? productName;
  double? unitPrice;
  int? stock;
  int? productCodeGroupId;
  int? colorId;
  String? colorName;
  int? sizeId;
  String? sizeName;
  bool? durum;

  Map<String, dynamic> toJson() => throw UnimplementedError();
}
