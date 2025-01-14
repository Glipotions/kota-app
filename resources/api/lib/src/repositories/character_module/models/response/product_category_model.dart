import 'package:api/api.dart';


class ProductCategoryListResponseModel extends IBaseModel<ProductCategoryListResponseModel> {

  ProductCategoryListResponseModel({
    this.items,
  });
  final List<ProductCategoryModel>? items;

  @override
  ProductCategoryListResponseModel fromJson(Map<String, dynamic> json) {
    return ProductCategoryListResponseModel(
      items: json['items'] == null
          ? []
          : List<ProductCategoryModel>.from(
              json['items']!
                  .map((x) => ProductCategoryModel().fromJson(x)),
            ),
    );
  }

  @override
  Map<String, dynamic> toJson() => throw UnimplementedError();
}

class ProductCategoryModel extends IBaseModel<ProductCategoryModel> {
  final int? id;
  final String? name;
  final int? parentCategoryId;
  final List<ProductCategoryModel>? subCategories;

  ProductCategoryModel({
    this.id,
    this.name,
    this.parentCategoryId,
    this.subCategories,
  });

  @override
  ProductCategoryModel fromJson(Map<String, dynamic> json) {
    return ProductCategoryModel(
      id: json['id'],
      name: json['name'],
      parentCategoryId: json['parentCategoryId'],
      subCategories: json['subCategories'] == null
          ? []
          : List<ProductCategoryModel>.from(
              json['subCategories']!
                  .map((x) => ProductCategoryModel().fromJson(x)),
            ),
    );
  }

  @override
  Map<String, dynamic> toJson() => throw UnimplementedError();
}
