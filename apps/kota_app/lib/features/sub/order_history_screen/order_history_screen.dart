import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota_app/features/sub/order_history_screen/controller/order_history_controller.dart';
import 'package:kota_app/features/sub/order_history_screen/view/order_history.dart';

class OrderHistoryScreen extends StatelessWidget {
  const OrderHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      tag: UniqueKey().toString(),
      init: OrderHistoryController(),
      builder: (controller) => OrderHistory(controller: controller),
    );
  }
}
