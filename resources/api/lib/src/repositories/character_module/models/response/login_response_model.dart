import 'package:api/src/index.dart';

class LoginResponseModel extends IBaseModel<LoginResponseModel> {
  LoginResponseModel({
    this.accessToken,
    this.user,
  });

  String? accessToken;
  User? user;

  @override
  LoginResponseModel fromJson(Map<String, dynamic> json) => LoginResponseModel(
        accessToken: json['accessToken'],
        user: json['user'] == null ? null : User().fromJson(json['user']),
      );

  @override
  Map<String, dynamic> toJson() => throw UnimplementedError();
}

class User extends IBaseModel<User> {
  User({
    this.id,
    this.username,
    this.fullName,
    this.email,
    this.hasCurrentAccount,
    this.periodId,
    this.createdDate,
    this.updatedDate,
    this.currentAccountId,
  });

  int? id;
  int? currentAccountId;
  String? username;
  String? fullName;
  String? email;
  bool? hasCurrentAccount;
  int? periodId;
  DateTime? createdDate;
  DateTime? updatedDate;

  @override
  User fromJson(Map<String, dynamic> json) => User(
        id: json['id'],
        currentAccountId: json['currentAccountId'],
        hasCurrentAccount: json['hasCurrentAccount'],
        periodId: json['periodId'],
        username: json['username'],
        fullName: json['fullName'],
        email: json['email'],
        createdDate: json['createdDate'] == null
            ? null
            : DateTime.parse(json['createdDate']),
        updatedDate: json['updatedDate'],
      );

  @override
  Map<String, dynamic> toJson() => throw UnimplementedError();
}
