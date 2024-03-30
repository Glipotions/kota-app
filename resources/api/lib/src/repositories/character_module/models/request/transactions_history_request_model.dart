import 'package:api/src/index.dart';

class TransactionsHistoryRequestModel
    extends IBaseModel<TransactionsHistoryRequestModel> {
  TransactionsHistoryRequestModel({
    required this.pageIndex,
    required this.pageSize,
    required this.id,
  });
  int pageIndex;
  int pageSize;
  int id;

  @override
  Map<String, dynamic> toJson() => {
        'PageIndex': pageIndex.toString(),
        'PageSize': pageSize.toString(),
        'id': id.toString(),
      };

  @override
  TransactionsHistoryRequestModel fromJson(Map<String, dynamic> json) =>
      throw UnimplementedError();
}
