import 'product_category.dart';

enum ProductSortType {
  priceAsc,
  priceDesc,
  nameAsc,
  nameDesc,
}

class ProductFilter {
  ProductFilter({
    this.minPrice,
    this.maxPrice,
    this.sortType,
    this.category,
  });

  final double? minPrice;
  final double? maxPrice;
  final ProductSortType? sortType;
  final ProductCategory? category;

  ProductFilter copyWith({
    double? minPrice,
    double? maxPrice,
    ProductSortType? sortType,
    ProductCategory? category,
  }) {
    return ProductFilter(
      minPrice: minPrice ?? this.minPrice,
      maxPrice: maxPrice ?? this.maxPrice,
      sortType: sortType ?? this.sortType,
      category: category ?? this.category,
    );
  }
}
