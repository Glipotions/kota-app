import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:kota_app/product/base/controller/base_controller.dart';
import 'package:kota_app/product/services/pdf_service.dart';

class SalesInvoiceDetailController extends BaseControllerInterface {
  SalesInvoiceDetailController({required this.id});

  final int id;
  bool isLoading = true;
  SalesInvoiceDetailResponseModel? salesInvoiceDetail;

  @override
  void onInit() {
    super.onInit();
    fetchSalesInvoiceDetail();
  }

  Future<void> fetchSalesInvoiceDetail() async {
    try {
      final response = await client.appService.saleInvoiceDetail(id: id);
      if (response.data != null) {
        salesInvoiceDetail = response.data;
      }
    } catch (e) {
      // CustomSnackBar.error(message: e.toString());
    } finally {
      isLoading = false;
      update();
    }
  }
  
  /// Generates and shows a PDF invoice
  Future<void> generateAndShowInvoice(BuildContext context) async {
    if (salesInvoiceDetail == null) return;
    
    try {
      final pdfBytes = await PDFService.generateInvoicePDF(
        salesInvoiceDetail!,
        context,
      );
      
      if (context.mounted) {
        await PDFService.showPDF(
          context,
          pdfBytes,
          'Satış Faturası #$id',
        );
      }
    } catch (e) {
      debugPrint('PDF generation error: $e');
      // Handle error
    }
  }
}
