import 'package:api/src/index.dart';

class RegisterRequestModel extends IBaseModel<RegisterRequestModel> {

  RegisterRequestModel({
    required this.email,
    required this.password,
    required this.fullName,
    required this.userName,
  });
  
  String email;
  String password;
  String fullName;
  String userName;

  @override
  Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'fullName': fullName,
        'userName': userName,
      };

  @override
  RegisterRequestModel fromJson(Map<String, dynamic> json) =>
      throw UnimplementedError();
}
