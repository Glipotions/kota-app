// ignore_for_file: omit_local_variable_types

import 'dart:convert';

import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:kota_app/product/base/controller/base_controller.dart';
import 'package:kota_app/product/models/cart_product_model.dart';
import 'package:kota_app/product/navigation/modules/sub_route/sub_route_enums.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:widgets/widget.dart';

class CartController extends BaseControllerInterface {
  static const String _cartKey = 'cart_items';
  final Rx<List<CartProductModel>> _itemList = Rx([]);
  final RxBool isDescriptionVisible = false.obs;
  final TextEditingController descriptionController = TextEditingController();

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
        final List<dynamic> decodedList = json.decode(cartJson) as List<dynamic>;
        itemList = decodedList
            .map((item) => CartProductModel.fromJson(item as Map<String, dynamic>))
            .toList();
      }
    } catch (e) {
      debugPrint('Error loading cart items: $e');
    }
  }

  Future<void> _saveCartItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String cartJson = json.encode(itemList.map((item) => item.toJson()).toList());
      await prefs.setString(_cartKey, cartJson);
    } catch (e) {
      debugPrint('Error saving cart items: $e');
    }
  }

  Future<void> clearCart() async {
    itemList = [];
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartKey);
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

  Future<void> onTapCompleteOrder() async {
    if (sessionHandler.currentUser == null) {
      // await SessionHandler.instance.logOut();
    await  context.pushNamed(SubRouteEnums.loginSubScreen.name);
    } else {
      final request = CreateOrderRequestModel(
        cariHesapId: sessionHandler.currentUser!.currentAccountId!.toString(),
        description: descriptionController.text.trim(),
        orderDetails: itemList
            .map(
              (e) => OrderDetail(
                amount: e.quantity.toString(),
                productId: e.id.toString(),
                unitPrice: e.price.toString(),
              ),
            )
            .toList(),
      );

      LoadingProgress.start();
      await client.appService.createOrder(request: request).handleRequest(
            ignoreException: true,
            onIgnoreException: (err) {
              showErrorToastMessage(err?.title ?? 'Bir hata oluştu.');
            },
            onSuccess: (res) {
              showSuccessToastMessage('Sipariş başarı ile oluşturuldu.');
              itemList = [];
              clearCart();
            },
            defaultResponse: CreateOrderResponseModel(),
          );
      LoadingProgress.stop();
    }
  }

  @override
  void onClose() {
    descriptionController.dispose();
    super.onClose();
  }
}
