import 'package:bb_example_app/features/sub/transaction_history_screen/controller/transaction_history_controller.dart';
import 'package:bb_example_app/features/sub/transaction_history_screen/view/transaction_history.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class TransactionHistoryScreen extends StatelessWidget {
  const TransactionHistoryScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      tag: UniqueKey().toString(),
      init: TransactionHistoryController(),
      builder: (controller) => TransactionHistory(controller: controller),
    );
  }
}
