import 'package:bb_example_app/features/auth/register_screen/controller/register_controller.dart';
import 'package:bb_example_app/features/auth/register_screen/view/register.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

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
