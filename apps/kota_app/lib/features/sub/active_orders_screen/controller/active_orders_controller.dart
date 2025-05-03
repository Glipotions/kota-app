import 'package:api/src/repositories/character_module/models/response/active_orders_response_model.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota_app/features/sub/active_orders_screen/active_orders_pdf_controller.dart';
import 'package:kota_app/product/base/controller/base_controller.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart'; 

enum LoadingState { idle, loading, success, error }

class ActiveOrdersController extends BaseControllerInterface {
  final Rx<LoadingState> loadingState = LoadingState.idle.obs;
  final RxList<AlinanSiparisBilgileriL> activeOrders = <AlinanSiparisBilgileriL>[].obs;
  final RxBool isCurrencyTL = true.obs; 

  bool get isLoading => loadingState.value == LoadingState.loading;
  bool get hasError => loadingState.value == LoadingState.error;
  bool get isIdle => loadingState.value == LoadingState.idle;
  bool get isSuccess => loadingState.value == LoadingState.success;

  @override
  void onInit() {
    super.onInit();
    fetchActiveOrders();
  }

  Future<void> fetchActiveOrders() async {
    try {
      loadingState.value = LoadingState.loading;
      errorMessage = '';  
      activeOrders.clear(); 

      final response =
          await client.appService.getActiveOrders(
            id: sessionHandler.currentUser!.currentAccountId!,
            branchCurrentInfoId: sessionHandler.currentUser!.connectedBranchCurrentInfoId,
          );

      // Check the inner data and its 'items' list
      if (response.data?.items != null) {
        activeOrders.assignAll(response.data!.items!); // Use ! because we checked for null
        loadingState.value = LoadingState.success;
      } else {
        // Handle API error or empty data using BaseErrorModel fields
        errorMessage = response.error?.detail ?? 
                             response.error?.title ?? 
                             'Aktif siparişler alınamadı.'; // Default error message
        loadingState.value = LoadingState.error;
      }
    } catch (e, stackTrace) { 
      errorMessage = 'Bir hata oluştu: ${e.toString()}';
      loadingState.value = LoadingState.error;
      print('Error fetching active orders: $e\n$stackTrace'); 
    }
  }

  // Method to generate and show the PDF
  Future<void> showActiveOrdersPdf() async {
    if (activeOrders.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Görüntülenecek aktif sipariş bulunmuyor.'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Kapat',
            onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
          ),
        ),
      );
      return;
    }

    try {
      // Instantiate the PDF controller
      final pdfController = ActiveOrdersPdfController();
      // Generate the PDF Document (ensure Get.context! is not null here)
      final pw.Document pdfDocument = await pdfController.generateActiveOrdersPdf(
          activeOrders.toList(),
          context, // Pass context for localization
          isCurrencyTL.value, // Pass currency flag
      );

      // Use the printing package to show the PDF preview
      await Printing.layoutPdf(
        // Save the document to Uint8List inside the layout callback
        onLayout: (format) async => pdfDocument.save(),
        name: 'aktif_siparisler.pdf', // Optional: name for the PDF file
      );

    } catch (e, stackTrace) {
      print('Error generating or displaying PDF: $e\n$stackTrace');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('PDF oluşturulurken bir hata oluştu.'),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
          action: SnackBarAction(
            label: 'Kapat',
            onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
          ),
        ),
      );
    }
  }
}
