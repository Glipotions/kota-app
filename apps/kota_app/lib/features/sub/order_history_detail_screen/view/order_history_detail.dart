import 'package:flutter/material.dart';
import 'package:kota_app/product/base/base_view.dart';
import 'package:kota_app/product/widgets/app_bar/general_app_bar.dart';

// ignore: always_use_package_imports
import '../controller/order_history_detail_controller.dart';

class OrderHistoryDetail extends StatelessWidget {
  const OrderHistoryDetail({required this.controller, super.key});

  final OrderHistoryDetailController controller;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      appBar: const GeneralAppBar(title: 'Empty'),
      body: BaseView<OrderHistoryDetailController>(
        controller: controller,
        child: const SizedBox(),),
    );
  }
}
