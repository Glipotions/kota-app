import 'package:api/src/index.dart';

class UserOperationClaimResponseModel
    extends IBaseModel<UserOperationClaimResponseModel> {

  UserOperationClaimResponseModel({
    this.id,
    this.userId,
    this.operationClaimId,
    this.operationClaimName,
  });
  int? id;
  int? userId;
  int? operationClaimId;
  String? operationClaimName;

  @override
  UserOperationClaimResponseModel fromJson(Map<String, dynamic> json) =>
      UserOperationClaimResponseModel(
        id: json['id'],
        userId: json['userId'],
        operationClaimId: json['operationClaimId'],
        operationClaimName: json['operationClaimName'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'operationClaimId': operationClaimId,
        'operationClaimName': operationClaimName,
      };
}
