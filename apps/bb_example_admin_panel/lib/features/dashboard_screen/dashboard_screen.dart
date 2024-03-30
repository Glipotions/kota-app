import 'package:bb_example_admin_panel/features/dashboard_screen/controller/dashboard_controller.dart';
import 'package:bb_example_admin_panel/features/dashboard_screen/view/dashboard.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///Widget for initializing GetxController for Example Screen
class DashboardScreen extends StatelessWidget {
  ///Widget for initializing GetxController for Example Screen
  const DashboardScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder<DashboardController>(
      init: DashboardController(),
      builder: (DashboardController controller) {
        return Dashboard(
          controller: controller,
        );
      },
    );
  }
}
