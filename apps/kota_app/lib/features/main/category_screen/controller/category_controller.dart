import 'package:kota_app/product/base/controller/base_controller.dart';

class CategoryController extends BaseControllerInterface {

  @override
  Future<void> onReady() async {
    super.onReady();
    await onReadyGeneric(() async {
    });
  }


}
