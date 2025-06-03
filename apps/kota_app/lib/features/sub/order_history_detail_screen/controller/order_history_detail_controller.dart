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
        cartProductItems.clear(); // Clear existing items to prevent duplication

        for (final item in res.items!) {
          cartProductItems.add(
            CartProductModel(
              id: item.urunId!, // Use urunId instead of id for product identification
              code: item.code!,
              price: item.birimFiyat!,
              quantity: item.miktar!,
              name: item.name,
              pictureUrl: item.pictureUrl,
              currencyUnitPrice: item.dovizliBirimFiyat,
              orderDetailId: item.id, // Keep order detail ID for reference
              // Include discount rate from order level
              discountRate: res.iskontoOrani ?? 0,
            ),
          );
        }
        cartProductItems = cartProductItems;
      },
    );

    _isLoading.value = false;
  }

  /// Aktif siparişleri getirir ve mevcut ürünlerle birleştirir
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

          // Merge active order information with existing cart products instead of duplicating
          for (final order in filteredOrders) {
            // Find existing product by product ID (urunId)
            final existingProductIndex = cartProductItems.indexWhere(
              (product) => product.id == order.urunId,
            );

            if (existingProductIndex != -1) {
              // Update existing product with remaining quantity information
              final existingProduct = cartProductItems[existingProductIndex];
              cartProductItems[existingProductIndex] = CartProductModel(
                id: existingProduct.id,
                code: existingProduct.code,
                price: existingProduct.price,
                quantity: existingProduct.quantity,
                name: existingProduct.name,
                pictureUrl: existingProduct.pictureUrl,
                currencyUnitPrice: existingProduct.currencyUnitPrice,
                orderDetailId: existingProduct.orderDetailId,
                discountRate: existingProduct.discountRate,
                remainingQuantity: order.kalanAdet, // Add remaining quantity info
                sizeName: existingProduct.sizeName,
                colorName: existingProduct.colorName,
                productCodeGroupId: existingProduct.productCodeGroupId,
              );
            }
            // If product doesn't exist in cart items, it means it's a separate active order
            // We'll show these in the separate active orders section
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
