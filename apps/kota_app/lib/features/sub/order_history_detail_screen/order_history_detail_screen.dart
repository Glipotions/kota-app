// ignore_for_file: always_use_package_imports

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/order_history_detail_controller.dart';
import 'view/order_history_detail.dart';

class OrderHistoryDetailScreen extends StatelessWidget {
  const OrderHistoryDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      tag: UniqueKey().toString(),
      init: OrderHistoryDetailController(),
      builder: (controller) => OrderHistoryDetail(controller: controller),
    );
  }
}
