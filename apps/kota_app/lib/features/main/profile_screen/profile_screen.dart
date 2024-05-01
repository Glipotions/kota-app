import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota_app/features/main/profile_screen/controller/profile_controller.dart';
import 'package:kota_app/features/main/profile_screen/view/profile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      tag: UniqueKey().toString(),
      init: ProfileController(),
      builder: (controller) => Profile(controller: controller),
    );
  }
}
