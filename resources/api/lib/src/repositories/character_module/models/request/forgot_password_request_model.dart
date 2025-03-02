import 'package:api/src/index.dart';

/// Request model for sending forgot password code
class ForgotPasswordRequestModel extends IBaseModel<ForgotPasswordRequestModel> {
  /// Constructor
  ForgotPasswordRequestModel({
    required this.email,
  });

  /// Email address to send verification code
  final String email;

  @override
  ForgotPasswordRequestModel fromJson(Map<String, dynamic> json) => ForgotPasswordRequestModel(
        email: json['email'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'email': email,
      };
}

/// Request model for verifying forgot password code
class VerifyForgotPasswordRequestModel extends IBaseModel<VerifyForgotPasswordRequestModel> {
  /// Constructor
  VerifyForgotPasswordRequestModel({
    required this.email,
    required this.code,
  });

  /// Email address
  final String email;
  
  /// Verification code
  final String code;

  @override
  VerifyForgotPasswordRequestModel fromJson(Map<String, dynamic> json) => VerifyForgotPasswordRequestModel(
        email: json['email'],
        code: json['code'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'email': email,
        'code': code,
      };
}

/// Request model for resetting password
class ResetPasswordRequestModel extends IBaseModel<ResetPasswordRequestModel> {
  /// Constructor
  ResetPasswordRequestModel({
    required this.email,
    required this.code,
    required this.newPassword,
  });

  /// Email address
  final String email;
  
  /// Verification code
  final String code;
  
  /// New password
  final String newPassword;

  @override
  ResetPasswordRequestModel fromJson(Map<String, dynamic> json) => ResetPasswordRequestModel(
        email: json['email'],
        code: json['code'],
        newPassword: json['newPassword'],
      );

  @override
  Map<String, dynamic> toJson() => {
        'email': email,
        'code': code,
        'newPassword': newPassword,
      };
}
