import 'package:bb_example_app/features/navigation/bottom_navigation_bar/controller/bottom_navigation_controller.dart';
import 'package:bb_example_app/features/navigation/bottom_navigation_bar/view/bottom_navigation_bar_view.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

///Widget for initializing GetxController for [BottomNavigationBarScreen]
class BottomNavigationBarScreen extends StatelessWidget {
  ///Widget for initializing GetxController for [BottomNavigationBarScreen]
  const BottomNavigationBarScreen({required this.child, super.key});

  ///Child that represnt the current View based on
  ///selected BottomNavigationBar index
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      init: BottomNavigationController(),
      builder: (_) => BottomNavigationBarView(child: child),
    );
  }
}
