import 'package:bb_example_admin_panel/features/navigation/main_screen/controller/main_controller.dart';
import 'package:bb_example_admin_panel/features/navigation/main_screen/view/main_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///Widget for initializing GetxController for [MainScreen]
class MainScreen extends StatelessWidget {
  ///Widget for initializing GetxController for [MainScreen]
  const MainScreen({required this.child, super.key});

  ///Child that represnt the current View based on
  ///selected BottomNavigationBar index
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: MainController(),
      builder: (controller) => MainView(
        controller: controller,
        child: child,
      ),
    );
  }
}
