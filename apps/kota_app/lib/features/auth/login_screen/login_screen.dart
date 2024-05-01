import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota_app/features/auth/login_screen/controller/login_controller.dart';
import 'package:kota_app/features/auth/login_screen/view/login.dart';

///Widget for initializing GetxController for Example Screen
class LoginScreen extends StatelessWidget {
  ///Widget for initializing GetxController for Example Screen
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<LoginController>(
      tag: UniqueKey().toString(),
      init: LoginController(),
      builder: (LoginController controller) => Login(
        controller: controller,
      ),
    );
  }
}
