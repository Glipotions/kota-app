import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota_app/features/auth/register_screen/controller/register_controller.dart';
import 'package:kota_app/features/auth/register_screen/view/register.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      tag: UniqueKey().toString(),
      init: RegisterController(),
      builder: (controller) => Register(controller: controller),
    );
  }
}
