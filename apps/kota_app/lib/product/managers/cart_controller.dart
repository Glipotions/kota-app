// ignore_for_file: omit_local_variable_types

import 'dart:convert';

import 'package:api/api.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:kota_app/features/sub/current_account_screen/view/current_account.dart';
import 'package:kota_app/product/base/controller/base_controller.dart';
import 'package:kota_app/product/consts/claims.dart';
import 'package:kota_app/product/managers/session_handler.dart';
import 'package:kota_app/product/models/cart_product_model.dart';
import 'package:kota_app/product/navigation/modules/sub_route/sub_route_enums.dart';
import 'package:kota_app/product/utility/enums/currency_type.dart';
import 'package:kota_app/product/utility/enums/general.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:widgets/widget.dart';

class CartController extends BaseControllerInterface {
  static const String _cartKey = 'cart_items';
  final Rx<List<CartProductModel>> _itemList = Rx([]);
  final RxBool isDescriptionVisible = false.obs;
  final TextEditingController descriptionController = TextEditingController();
  RxInt? editingOrderId = RxInt(0);

  // Currency related cached values
  late final Rx<int> _currencyType = 1.obs;
  late final Rx<bool> _isCurrencyTL = true.obs;

  // Discount rate for the entire cart (0-100%)
  final RxDouble cartDiscountRate = RxDouble(0);
  final TextEditingController discountController = TextEditingController(text: '0');

  // Check if user has admin rights
  bool get hasAdminRights => SessionHandler.instance.hasClaim(saleInvoiceAdminClaim);

  List<CartProductModel> get itemList => _itemList.value;
  set itemList(List<CartProductModel> value) => _itemList
    ..firstRebuild = true
    ..value = value;

  int get currencyType => _currencyType.value;
  bool get isCurrencyTL => _isCurrencyTL.value;

  void updateCurrencyValues() {
    _currencyType.value = sessionHandler.currentUser?.currencyType ?? 1;
    _isCurrencyTL.value = CurrencyType.tl == CurrencyType.fromValue(_currencyType.value);
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    await onReadyGeneric(() async {
      updateCurrencyValues();
      await loadCartItems();
    });
  }

  Future<void> loadCartItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? cartJson = prefs.getString(_cartKey);
      if (cartJson != null) {
        final List<dynamic> decodedList =
            json.decode(cartJson) as List<dynamic>;
        itemList = decodedList
            .map(
              (item) => CartProductModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();
      }
    } catch (e) {
      debugPrint('Error loading cart items: $e');
    }
  }

  Future<void> _saveCartItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String cartJson =
          json.encode(itemList.map((item) => item.toJson()).toList());
      await prefs.setString(_cartKey, cartJson);
    } catch (e) {
      debugPrint('Error saving cart items: $e');
    }
  }

  Future<void> clearCart() async {
    editingOrderId?.value = 0;
    itemList = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartKey);
    descriptionController.text = '';
    discountController.text = '0';
    cartDiscountRate.value = 0;
  }

  void onTapAddProduct(CartProductModel item) {
    // updateCurrencyValues();
    if (item.quantity == 0) {
      onTapRemoveProduct(item);
    }
    if (itemList.indexWhere((element) => element.id == item.id) != -1) {
      itemList.removeWhere((element) => element.id == item.id);
    }
    itemList.add(item);
    itemList = itemList;
    _saveCartItems();
  }

  void onTapRemoveProduct(CartProductModel item) {
    if (itemList.indexWhere((element) => element.id == item.id) != -1) {
      itemList.removeWhere((element) => element.id == item.id);
    }
    itemList = itemList;
    _saveCartItems();
  }

  CartProductModel? inChartItemById(int id) =>
      itemList.firstWhereOrNull((element) => element.id == id);

  double totalAmount({bool withDiscount = true}) {
    double totalAmount = 0;
    double totalCurrencyAmount = 0;

    for (final element in itemList) {
      totalAmount = totalAmount + (element.price * element.quantity);
      if (element.currencyUnitPrice != null) {
        totalCurrencyAmount =
            totalCurrencyAmount + (element.currencyUnitPrice! * element.quantity);
      }
    }

    final baseAmount = isCurrencyTL ? totalAmount : totalCurrencyAmount;

    // Apply discount if requested
    if (withDiscount && cartDiscountRate.value > 0) {
      final discountAmount = baseAmount * (cartDiscountRate.value / 100);
      return baseAmount - discountAmount;
    }

    return baseAmount;
  }

  // Calculate the discount amount
  double discountAmount() {
    final baseAmount = totalAmount(withDiscount: false);
    return baseAmount * (cartDiscountRate.value / 100);
  }

  // Update discount rate from the text field
  void updateDiscountRate(String value) {
    try {
      final newRate = double.parse(value);
      if (newRate >= 0 && newRate <= 100) {
        cartDiscountRate.value = newRate;

        // Apply the discount rate to all items in the cart
        for (final item in itemList) {
          item.discountRate = newRate;
        }

        // Update the cart items to trigger UI refresh
        itemList = List<CartProductModel>.from(itemList);
        _saveCartItems();
      }
    } catch (e) {
      debugPrint('Error parsing discount rate: $e');
    }
  }

  Future<void> completeOrder(BuildContext context) async {
    if (itemList.isEmpty) {
      showErrorToastMessage('Sepetiniz boş');
      return;
    }

    if (sessionHandler.currentUser == null) {
      await context.pushNamed(SubRouteEnums.loginSubScreen.name);
      return;
    }

    // Admin yetkisi varsa cari hesap seçme ekranını göster
    if (SessionHandler.instance.hasClaim(saleInvoiceAdminClaim)) {
      final result = await Navigator.push<GetCurrentAccount>(
        context,
        MaterialPageRoute(
          builder: (context) => const CurrentAccount(
            pageStatusEnum: ScreenArgumentEnum.SelectToBack,
          ),
        ),
      );

      if (result == null) return;

      // Onay dialogu göster
      final confirmed = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          final labels = AppLocalization.getLabels(context);
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Theme.of(context).cardColor,
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.shopping_cart_checkout,
                    size: 48,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  labels.orderConfirmationTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
              ],
            ),
            content: Text(
              labels.orderConfirmationMessage(result.firma!),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  labels.cancel,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  labels.confirm,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                ),
              ),
            ],
          );
        },
      );

      if (confirmed != true) return;

      await _completeOrder(result.id.toString(), context);
    } else {
      await _completeOrder(
        sessionHandler.currentUser!.currentAccountId!.toString(),
        context,
      );
    }
  }

  Future<void> _completeOrder(String cariHesapId, BuildContext context) async {
    // Dismiss keyboard before proceeding
    FocusScope.of(context).unfocus();

    LoadingProgress.start();
    try {
      // Note: The discount rate is stored locally but not sent to the API yet
      // The API model needs to be updated to include discount rate fields
      final request = CreateOrderRequestModel(
        id: editingOrderId?.value,
        cariHesapId: cariHesapId,
        connectedBranchCurrentInfoId:
            SessionHandler.instance.currentUser!.connectedBranchCurrentInfoId,
        description: descriptionController.text.trim() +
            (cartDiscountRate.value > 0
                ? ' (İskonto: %${cartDiscountRate.value.toStringAsFixed(2)})'
                : ''),
        orderDetails: itemList
            .map(
              (e) => OrderDetail(
                id: e.orderDetailId ?? 0,
                amount: e.quantity.toString(),
                productId: e.id.toString(),
                // If discount is applied, send the discounted price
                unitPrice: (e.price * (1 - e.discountRate / 100)).toString(),
                currencyUnitPrice: e.currencyUnitPrice != null
                    ? (e.currencyUnitPrice! * (1 - e.discountRate / 100)).toString()
                    : null,
              ),
            )
            .toList(),
        currencyType: currencyType,
      );

      if (editingOrderId?.value != 0) {
        // Sipariş güncelleme
        await client.appService.updateOrder(request: request).handleRequest(
              onSuccess: (res) async {
                final labels = AppLocalization.getLabels(context);
                await clearCart();
                showSuccessToastMessage(labels.orderUpdatedSuccessfully);
                // context.pop();
              },
              onIgnoreException: (error) {
                final labels = AppLocalization.getLabels(context);
                showErrorToastMessage(labels.orderUpdateError);
              },
              ignoreException: true,
              defaultResponse: CreateOrderResponseModel(),
            );
      } else {
        // Yeni sipariş oluşturma
        await client.appService.createOrder(request: request).handleRequest(
              onSuccess: (res) async {
                final labels = AppLocalization.getLabels(context);
                await clearCart();
                showSuccessToastMessage(labels.orderCreatedSuccessfully);
                // context.pop();
              },
              onIgnoreException: (error) {
                final labels = AppLocalization.getLabels(context);
                showErrorToastMessage(labels.orderCreateError);
              },
              ignoreException: true,
              defaultResponse: CreateOrderResponseModel(),
            );
      }
    } finally {
      LoadingProgress.stop();
    }
  }

  @override
  void onClose() {
    descriptionController.dispose();
    discountController.dispose();
    super.onClose();
  }
}
