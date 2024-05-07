import 'package:flutter/material.dart';
import 'package:kota_app/product/base/base_view.dart';
import 'package:kota_app/product/widgets/app_bar/general_app_bar.dart';

// ignore: always_use_package_imports
import '../controller/category_controller.dart';

class Category extends StatelessWidget {
  const Category({required this.controller, super.key});

  final CategoryController controller;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      appBar: const GeneralAppBar(title: 'Kategori'),
      body: BaseView<CategoryController>(
        controller: controller,
        child: const SizedBox(),),
    );
  }
}
