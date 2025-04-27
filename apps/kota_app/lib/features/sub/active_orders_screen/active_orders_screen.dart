import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota_app/features/sub/active_orders_screen/controller/active_orders_controller.dart';
import 'package:kota_app/features/sub/active_orders_screen/view/active_orders.dart';

class ActiveOrdersScreen extends StatelessWidget {
  const ActiveOrdersScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      tag: UniqueKey().toString(),
      init: ActiveOrdersController(),
      builder: (controller) => ActiveOrders(controller: controller),
    );
  }
}
