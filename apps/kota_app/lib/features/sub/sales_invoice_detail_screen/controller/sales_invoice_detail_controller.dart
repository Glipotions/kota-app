import 'package:api/api.dart';
import 'package:kota_app/product/base/controller/base_controller.dart';

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
}
