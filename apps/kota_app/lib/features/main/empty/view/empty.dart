import 'package:flutter/material.dart';
import 'package:kota_app/product/base/base_view.dart';
import 'package:kota_app/product/widgets/app_bar/general_app_bar.dart';

// ignore: always_use_package_imports
import '../controller/empty_controller.dart';

class Empty extends StatelessWidget {
  const Empty({required this.controller, super.key});

  final EmptyController controller;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      appBar: const GeneralAppBar(title: 'Empty'),
      body: BaseView<EmptyController>(
        controller: controller,
        child: const SizedBox(),),
    );
  }
}
