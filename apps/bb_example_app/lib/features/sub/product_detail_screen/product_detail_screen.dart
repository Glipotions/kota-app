import 'package:bb_example_app/features/sub/product_detail_screen/controller/product_detail_controller.dart';
import 'package:bb_example_app/features/sub/product_detail_screen/view/product_detail.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class ProductDetailScreen extends StatelessWidget {
  const ProductDetailScreen({
    required this.id,
    required this.productCode,
    super.key,
  });

  final String id;
  final String productCode;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      tag: UniqueKey().toString(),
      init: ProductDetailController(code: id, productCode: productCode),
      builder: (controller) => ProductDetail(controller: controller),
    );
  }
}
