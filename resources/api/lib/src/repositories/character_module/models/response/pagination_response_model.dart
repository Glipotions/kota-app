import 'package:api/api.dart';

class PaginationResponseModel<T>
    extends IBaseModel<PaginationResponseModel<T>> {
  PaginationResponseModel({
    this.items,
    this.index,
    this.size,
    this.count,
    this.pages,
    this.hasPrevious,
    this.hasNext,
  });

  factory PaginationResponseModel.fromJson(
    Map<String, dynamic> json,
    T Function(Map<String, dynamic>) createItemT,
  ) {
    final itemList = json['items'] as List? ?? [];
    final itemsConverted =
        itemList.map<T>((itemJson) => createItemT(itemJson)).toList();
    return PaginationResponseModel<T>(
      items: itemsConverted,
      index: json['index'],
      size: json['size'],
      count: json['count'],
      pages: json['pages'],
      hasPrevious: json['hasPrevious'],
      hasNext: json['hasNext'],
    );
  }

  List<T>? items;
  int? index;
  int? size;
  int? count;
  int? pages;
  bool? hasPrevious;
  bool? hasNext;
  @override
  Map<String, dynamic> toJson() => throw UnimplementedError();

  @override
  PaginationResponseModel<T> fromJson(Map<String, dynamic> json) {
    throw UnimplementedError();
  }
}
