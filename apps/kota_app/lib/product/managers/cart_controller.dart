// ignore_for_file: omit_local_variable_types

import 'package:api/api.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:kota_app/product/base/controller/base_controller.dart';
import 'package:kota_app/product/managers/session_handler.dart';
import 'package:kota_app/product/navigation/modules/sub_route/sub_route_enums.dart';
import 'package:widgets/widget.dart';

class CartController extends BaseControllerInterface {
  final Rx<List<CartProductModel>> _itemList = Rx([]);

  List<CartProductModel> get itemList => _itemList.value;
  set itemList(List<CartProductModel> value) => _itemList
    ..firstRebuild = true
    ..value = value;

  @override
  Future<void> onReady() async {
    super.onReady();
    await onReadyGeneric(() async {});
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
  }

  void onTapRemoveProduct(CartProductModel item) {
    if (itemList.indexWhere((element) => element.id == item.id) != -1) {
      itemList.removeWhere((element) => element.id == item.id);
    }
    itemList = itemList;
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
            },
            defaultResponse: CreateOrderResponseModel(),
          );
      LoadingProgress.stop();
    }
  }
}

class CartProductModel {
  CartProductModel({
    required this.id,
    required this.code,
    required this.price,
    required this.quantity,
    this.name,
    this.pictureUrl,
  });

  int id;
  String code;
  String? name;
  double price;
  int quantity;
  String? pictureUrl;

  CartProductModel copyWith({
    int? id,
    String? code,
    String? name,
    double? price,
    int? quantity,
    String? pictureUrl,
  }) {
    return CartProductModel(
      id: id ?? this.id,
      code: code ?? this.code,
      name: name ?? this.name,
      price: price ?? this.price,
      quantity: quantity ?? this.quantity,
      pictureUrl: pictureUrl ?? this.pictureUrl,
    );
  }
}
