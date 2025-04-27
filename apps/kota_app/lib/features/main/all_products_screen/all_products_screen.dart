import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota_app/features/main/all_products_screen/controller/all_products_controller.dart';
import 'package:kota_app/features/main/all_products_screen/view/all_products.dart';

class AllProductsScreen extends StatelessWidget {
  const AllProductsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      tag: 'all_products_controller',
      init: AllProductsController(),
      builder: (controller) => AllProducts(controller: controller),
    );
  }
}
