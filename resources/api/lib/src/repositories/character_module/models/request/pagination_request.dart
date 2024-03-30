import 'package:api/api.dart';

class PaginationRequestModel extends IBaseModel<PaginationRequestModel> {
  PaginationRequestModel({
    required this.pageIndex,
    required this.pageSize,
    this.searchText,
  });
  int pageIndex;
  int pageSize;
  String? searchText;

  @override
  Map<String, dynamic> toJson() => {
        'PageIndex': pageIndex.toString(),
        'PageSize': pageSize.toString(),
        'SearchText': searchText,
      };

  @override
  PaginationRequestModel fromJson(Map<String, dynamic> json) =>
      throw UnimplementedError();
}
