import 'package:api/api.dart';

class PaginationRequestModel extends IBaseModel<PaginationRequestModel> {
  PaginationRequestModel({
    this.pageIndex,
    this.pageSize,
    this.searchText,
    this.categoryId,
    this.minPrice,
    this.maxPrice,
    this.sortBy,
    this.sortDirection,
  });
  int? pageIndex;
  int? pageSize;
  String? searchText;
  int? categoryId;
  double? minPrice;
  double? maxPrice;
  String? sortBy;
  String? sortDirection;

  @override
  Map<String, dynamic> toJson() => {
        'PageIndex': pageIndex.toString(),
        'PageSize': pageSize.toString(),
        if (searchText != null) 'searchText': searchText.toString(),
        if (categoryId != null) 'categoryId': categoryId.toString(),
        if (minPrice != null) 'minPrice': minPrice.toString(),
        if (maxPrice != null) 'maxPrice': maxPrice.toString(),
        if (sortBy != null) 'sortBy': sortBy.toString(),
        if (sortDirection != null) 'sortDirection': sortDirection.toString(),
      };

  @override
  PaginationRequestModel fromJson(Map<String, dynamic> json) =>
      throw UnimplementedError();
}
