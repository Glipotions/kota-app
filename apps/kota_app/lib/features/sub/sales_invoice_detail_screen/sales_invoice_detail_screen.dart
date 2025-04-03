// ignore_for_file: always_use_package_imports

import 'package:flutter/material.dart';
import 'package:get/get.dart';

import 'controller/sales_invoice_detail_controller.dart';
import 'view/sales_invoice_detail.dart';

class SalesInvoiceDetailScreen extends StatelessWidget {
  const SalesInvoiceDetailScreen({
    required this.id,
    this.connectedBranchCurrentInfoId,
    super.key,
  });

  final String id;
  final String? connectedBranchCurrentInfoId;

  @override
  Widget build(BuildContext context) {
    return GetBuilder(
      tag: UniqueKey().toString(),
      init: SalesInvoiceDetailController(
        id: int.parse(id),
        connectedBranchCurrentInfoId: connectedBranchCurrentInfoId == null ||
                (connectedBranchCurrentInfoId?.isBlank ?? true)
            ? null
            : int.parse(connectedBranchCurrentInfoId!),
      ),
      builder: (controller) => SalesInvoiceDetail(controller: controller),
    );
  }
}
