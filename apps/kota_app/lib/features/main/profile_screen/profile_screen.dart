import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota_app/features/main/profile_screen/controller/profile_controller.dart';
import 'package:kota_app/features/main/profile_screen/view/profile.dart';
import 'package:kota_app/product/managers/session_handler.dart';
import 'package:kota_app/features/auth/login_screen/login_screen.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // Kullanıcı login değilse controller başlatmadan sadece login ekranı göster
    if (SessionHandler.instance.currentUser == null) {
      return const LoginScreen();
    }
    return GetBuilder(
      tag: UniqueKey().toString(),
      init: ProfileController(),
      builder: (controller) => Profile(controller: controller),
    );
  }
}
