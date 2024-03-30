import 'package:api/src/index.dart';

class LoginRequestModel extends IBaseModel<LoginRequestModel> {

    LoginRequestModel({
        required this.email,
        required this.password,
        this.authenticatorCode,
    });

    String email;
    String password;
    String? authenticatorCode;

    @override
      Map<String, dynamic> toJson() => {
        'email': email,
        'password': password,
        'authenticatorCode': authenticatorCode,
    };
    
      @override
  LoginRequestModel fromJson(Map<String, dynamic> json) =>
      throw UnimplementedError();
      
}
