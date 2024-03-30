import 'package:api/src/index.dart';

/// Base error model for parsing api errors.
class BaseErrorModel extends IBaseModel<BaseErrorModel> {
  /// Constructor
  BaseErrorModel({
    this.status,
    this.type,
    this.detail,
    this.title,
  });

  /// Message that represent that reason of the error
  String? type;
  String? detail;
  String? title;
  int? status;

  @override
  BaseErrorModel fromJson(Map<String, dynamic> json) => BaseErrorModel(
        status: json['status'],
        type: json['type'],
        detail: json['detail'],
        title: json['title'],
      );

  @override
  Map<String, dynamic> toJson() => throw UnimplementedError();
}
