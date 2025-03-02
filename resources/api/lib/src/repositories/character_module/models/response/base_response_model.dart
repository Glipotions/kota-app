import 'package:api/src/index.dart';

/// Base response model for simple API responses
class BaseResponseModel extends IBaseModel<BaseResponseModel> {
  /// Constructor
  BaseResponseModel({
    this.message,
    this.success = true,
  });

  /// Response message
  String? message;
  
  /// Success status
  bool success;

  @override
  BaseResponseModel fromJson(Map<String, dynamic> json) => BaseResponseModel(
        message: json['message'],
        success: json['success'] ?? true,
      );

  @override
  Map<String, dynamic> toJson() => throw UnimplementedError();
}
