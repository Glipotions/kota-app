import 'package:api/api.dart';

import 'package:api/api.dart';

class ProductCategory {
  final int id;
  final String name;
  final int? parentCategoryId;
  final List<ProductCategory> subCategories;

  ProductCategory({
    required this.id,
    required this.name,
    this.parentCategoryId,
    this.subCategories = const [],
  });

  factory ProductCategory.fromModel(ProductCategoryModel model) {
    return ProductCategory(
      id: model.id ?? 0,
      name: model.name ?? '',
      parentCategoryId: model.parentCategoryId,
      subCategories: model.subCategories?.map((e) => ProductCategory.fromModel(e)).toList() ?? [],
    );
  }

  bool get hasSubCategories => subCategories.isNotEmpty;
  bool get isSubCategory => parentCategoryId != null;

  // Tüm alt kategorileri düz liste olarak döndürür (recursive)
  List<ProductCategory> getAllSubCategories() {
    List<ProductCategory> allSubCategories = [];
    for (var category in subCategories) {
      allSubCategories.add(category);
      allSubCategories.addAll(category.getAllSubCategories());
    }
    return allSubCategories;
  }
}
