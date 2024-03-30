import 'package:bb_example_admin_panel/features/landing/splash_screen/controller/splash_controller.dart';
import 'package:bb_example_admin_panel/features/landing/splash_screen/view/splash.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///Widget for initializing GetxController for Example Screen
class SplashScreen extends StatelessWidget {
  ///Widget for initializing GetxController for Example Screen
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<SplashController>(
      init: SplashController(),
      builder: (SplashController controller) {
        return Splash(
          controller: controller,
        );
      },
    );
  }
}
