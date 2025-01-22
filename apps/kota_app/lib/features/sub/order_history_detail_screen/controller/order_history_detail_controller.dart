import 'package:api/api.dart';
import 'package:get/get.dart';
import 'package:kota_app/product/base/controller/base_controller.dart';
import 'package:kota_app/product/models/cart_product_model.dart';
import 'package:kota_app/product/utility/enums/currency_type.dart';

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

  late final Rx<int> _currencyType = 1.obs;
  late final Rx<bool> _isCurrencyTL = true.obs;
  int get currencyType => _currencyType.value;
  bool get isCurrencyTL => _isCurrencyTL.value;

  void _updateCurrencyValues() {
    _currencyType.value = sessionHandler.currentUser?.currencyType ?? 1;
    _isCurrencyTL.value = CurrencyType.tl == CurrencyType.fromValue(_currencyType.value);
  }

  bool get isLoading => _isLoading.value;

  @override
  Future<void> onReady() async {
    super.onReady();
    await onReadyGeneric(() async {
      _updateCurrencyValues();
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
              price: item.birimFiyat!,
              quantity: item.miktar!,
              name: item.name,
              pictureUrl: item.pictureUrl,
              currencyUnitPrice: item.dovizliBirimFiyat,
            ),
          );
        }
        cartProductItems = cartProductItems;
      },
    );
  }
}
