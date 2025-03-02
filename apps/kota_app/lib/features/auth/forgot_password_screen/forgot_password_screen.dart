import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota_app/features/auth/forgot_password_screen/controller/forgot_password_controller.dart';
import 'package:kota_app/features/auth/forgot_password_screen/view/forgot_password.dart';

/// Widget for initializing GetxController for Forgot Password Screen
class ForgotPasswordScreen extends StatelessWidget {
  /// Widget for initializing GetxController for Forgot Password Screen
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<ForgotPasswordController>(
      tag: UniqueKey().toString(),
      init: ForgotPasswordController(),
      builder: (ForgotPasswordController controller) => ForgotPassword(
        controller: controller,
      ),
    );
  }
}
