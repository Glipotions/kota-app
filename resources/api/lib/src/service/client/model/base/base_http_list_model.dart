import 'package:api/api.dart';

class BaseHttpListModel<T> extends BaseHttpModel<T> {
  String? message;
  String? errorCode;
  int? pageIndex;
  int? pageSize;
  int? pages;
  bool? hasPrevious;
  bool? hasNext;

  BaseHttpListModel({
    required super.status,
    super.data,
    this.message,
    this.errorCode,
    this.pageIndex,
    this.pageSize,
    this.pages,
    this.hasPrevious,
    this.hasNext,
  });
}
