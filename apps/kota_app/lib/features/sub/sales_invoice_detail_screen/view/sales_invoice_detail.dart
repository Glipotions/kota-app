import 'package:flutter/material.dart';

import 'package:kota_app/features/sub/sales_invoice_detail_screen/controller/sales_invoice_detail_controller.dart';
import 'package:kota_app/features/sub/sales_invoice_detail_screen/view/sales_invoice_items.dart';

class SalesInvoiceDetail extends StatelessWidget {
  const SalesInvoiceDetail({required this.controller, super.key});

  final SalesInvoiceDetailController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Satış Faturası Detay'),
      ),
      body: controller.isLoading
          ? const Center(child: CircularProgressIndicator())
          : controller.salesInvoiceDetail == null
              ? const Center(child: Text('Fatura detayı bulunamadı'))
              : SingleChildScrollView(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Ürün Bilgileri',
                        style: TextStyle(
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
