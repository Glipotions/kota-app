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
import 'package:kota_app/product/utility/enums/general.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:widgets/widget.dart';

class CartController extends BaseControllerInterface {
  static const String _cartKey = 'cart_items';
  final Rx<List<CartProductModel>> _itemList = Rx([]);
  final RxBool isDescriptionVisible = false.obs;
  final TextEditingController descriptionController = TextEditingController();
  RxInt? editingOrderId = RxInt(0);

  List<CartProductModel> get itemList => _itemList.value;
  set itemList(List<CartProductModel> value) => _itemList
    ..firstRebuild = true
    ..value = value;

  @override
  Future<void> onReady() async {
    super.onReady();
    await onReadyGeneric(() async {
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
  }

  void onTapAddProduct(CartProductModel item) {
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

  double totalAmount() {
    double totalAmount = 0;

    for (final element in itemList) {
      totalAmount = totalAmount + (element.price * element.quantity);
    }

    return totalAmount;
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
            backgroundColor: Colors.white,
            title: Text(
              labels.orderConfirmationTitle,
              style: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
            ),
            content: Text(
              labels.orderConfirmationMessage(result.firma!),
              style: const TextStyle(color: Colors.black87),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                style: TextButton.styleFrom(
                  foregroundColor: Colors.grey[800],
                ),
                child: Text(labels.cancel),
              ),
              TextButton(
                onPressed: () => Navigator.pop(context, true),
                style: TextButton.styleFrom(
                  foregroundColor: Theme.of(context).primaryColor,
                ),
                child: Text(labels.confirm),
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
    LoadingProgress.start();
    try {
      final request = CreateOrderRequestModel(
        id: editingOrderId?.value,
        cariHesapId: cariHesapId,
        connectedBranchCurrentInfoId:
            SessionHandler.instance.currentUser!.connectedBranchCurrentInfoId,
        description: descriptionController.text.trim(),
        orderDetails: itemList
            .map(
              (e) => OrderDetail(
                id: e.orderDetailId ?? 0,
                amount: e.quantity.toString(),
                productId: e.id.toString(),
                unitPrice: e.price.toString(),
              ),
            )
            .toList(),
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
    super.onClose();
  }
}
