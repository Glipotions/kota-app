import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota_app/product/base/controller/base_controller.dart';
import 'package:kota_app/product/models/cart_product_model.dart';
import 'package:kota_app/product/utility/enums/currency_type.dart';
import 'package:widgets/widget.dart';

class OrderHistoryDetailController extends BaseControllerInterface {
  OrderHistoryDetailController({required this.id, this.isActiveOrder = false});

  final int id;
  final bool isActiveOrder; // Aktif sipariş mi kontrolü
  final RxBool _isLoading = true.obs;
  OrdersHistoryDetailResponseModel responseModel =
      OrdersHistoryDetailResponseModel();
  final Rx<List<CartProductModel>> _cartProductModel = Rx([]);
  final Rx<List<AlinanSiparisBilgileriL>> _activeOrders = Rx([]);

  List<CartProductModel> get cartProductItems => _cartProductModel.value;
  set cartProductItems(List<CartProductModel> value) => _cartProductModel
    ..firstRebuild = true
    ..value = value;

  List<AlinanSiparisBilgileriL> get activeOrders => _activeOrders.value;
  set activeOrders(List<AlinanSiparisBilgileriL> value) => _activeOrders
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

      // Always fetch order content first
      await fetchOrderContent();

      // Then fetch active orders related to this order
      await fetchActiveOrders();
    });
  }

  /// Normal sipariş detaylarını getirir
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

    _isLoading.value = false;
  }

  /// Aktif siparişleri getirir
  Future<void> fetchActiveOrders() async {
    _isLoading.value = true;

    final currentAccountId = sessionHandler.currentUser!.currentAccountId!;

    await client.appService.getActiveOrders(id: currentAccountId, branchCurrentInfoId: sessionHandler.currentUser!.connectedBranchCurrentInfoId).handleRequest(
      onSuccess: (res) {
        if (res?.items != null) {
          final allActiveOrders = res!.items!;

          final filteredOrders = allActiveOrders
              .where((order) => order.alinanSiparisId == id)
              .toList();

          activeOrders = filteredOrders;

          // Ayrıca CartProductModel listesine de ekle
          for (final order in filteredOrders) {
            cartProductItems.add(
              CartProductModel(
                id: order.id!,
                code: order.urunKodu ?? '',
                price: order.birimFiyat ?? 0,
                quantity: order.miktar ?? 0,
                name: order.urunAdi,
                pictureUrl: null,
                currencyUnitPrice: order.dovizliBirimFiyat,
                remainingQuantity: order.kalanAdet,
              ),
            );
          }
          cartProductItems = cartProductItems;
        }
      },
      ignoreException: true,
      onIgnoreException: (error) {
        showErrorToastMessage('Aktif siparişler alınırken bir hata oluştu.');
      },
      defaultResponse: ActiveOrdersResponseModel(items: []),
    );

    _isLoading.value = false;
  }
}
