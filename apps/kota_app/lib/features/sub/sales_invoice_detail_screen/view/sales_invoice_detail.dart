import 'package:common/src/i10n/i10n.dart';
import 'package:flutter/material.dart';
import 'package:kota_app/features/sub/sales_invoice_detail_screen/controller/sales_invoice_detail_controller.dart';
import 'package:kota_app/features/sub/sales_invoice_detail_screen/view/sales_invoice_items.dart';

class SalesInvoiceDetail extends StatelessWidget {
  const SalesInvoiceDetail({required this.controller, super.key});

  final SalesInvoiceDetailController controller;

  @override
  Widget build(BuildContext context) {
    final labels = AppLocalization.getLabels(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(labels.invoiceDetail),
        actions: [
          if (!controller.isLoading && controller.salesInvoiceDetail != null)
            IconButton(
              icon: const Icon(Icons.picture_as_pdf),
              color: Colors.black,
              tooltip: labels.generateInvoicePdf,
              onPressed: () => controller.generateAndShowInvoice(context),
            ),
        ],
      ),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : controller.salesInvoiceDetail == null
              ? Center(child: Text(labels.invoiceDetailNotFound))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        labels.productInformation,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      SalesInvoiceItems(
                        items: controller.salesInvoiceDetail?.faturaBilgileri ?? [],
                      ),
                    ],
                  ),
                ),
    );
  }
}
