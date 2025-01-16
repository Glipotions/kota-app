import 'package:api/api.dart';

class ProductCategory {
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
      subCategories: model.subCategories
              ?.map(ProductCategory.fromModel)
              .toList() ??
          [],
    );
  }
  final int id;
  final String name;
  final int? parentCategoryId;
  final List<ProductCategory> subCategories;

  bool get hasSubCategories => subCategories.isNotEmpty;
  bool get isSubCategory => parentCategoryId != null;

  /// Tüm alt kategorileri düz liste olarak döndürür (recursive)
  List<ProductCategory> getAllSubCategories() {
    final allSubCategories = <ProductCategory>[];
    for (final category in subCategories) {
      allSubCategories
        ..add(category)
        ..addAll(category.getAllSubCategories());
    }
    return allSubCategories;
  }
}
