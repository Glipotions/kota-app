import 'package:api/api.dart';
import 'package:get/get.dart';
import 'package:kota_app/product/base/controller/base_controller.dart';
import 'package:kota_app/product/models/cart_product_model.dart';

class OrderHistoryDetailController extends BaseControllerInterface {
  OrderHistoryDetailController({required this.id});

  final int id;
  final RxBool _isLoading = true.obs;
  OrdersHistoryDetailResponseModel responseModel =
      OrdersHistoryDetailResponseModel();
  final Rx<List<CartProductModel>> _cartProductModel = Rx([]);

  List<CartProductModel> get cartProductItems => _cartProductModel.value;
  set cartProductItems(List<CartProductModel> value) => _cartProductModel
    ..firstRebuild = true
    ..value = value;

  bool get isLoading => _isLoading.value;

  @override
  Future<void> onReady() async {
    super.onReady();
    await onReadyGeneric(() async {
      await fetchOrderContent();
    });
  }

  Future<void> fetchOrderContent() async {
    _isLoading.value = true;

    await client.appService.orderHistoryDetail(id: id).handleRequest(
      onSuccess: (res) {
        responseModel = res!;
        for (final item in res.items!) {
          cartProductItems.add(
            CartProductModel(
              id: item.id!,
              code: item.code!,
              price: item.tutar!,
              quantity: item.miktar!,
              name: item.name,
            ),
          );
        }
        cartProductItems = cartProductItems;
      },
    );
  }
}
