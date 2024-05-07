// ignore_for_file: always_use_package_imports

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/empty_controller.dart';
import 'view/empty.dart';

class EmptyScreen extends StatelessWidget {
  const EmptyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      tag: UniqueKey().toString(),
      init: EmptyController(),
      builder: (controller) => Empty(controller: controller),
    );
  }
}
