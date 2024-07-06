import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:kota_app/product/base/controller/base_controller.dart';
import 'package:kota_app/product/navigation/modules/sub_route/sub_route_enums.dart';

class OrderHistoryController extends BaseControllerInterface {

  

  OrdersHistoryResponseModel transactionsResponse =
      OrdersHistoryResponseModel();

  final ScrollController scrollController = ScrollController();

  final Rx<List<OrderItem>> _orderItems = Rx([]);
  final Rx<bool> _isPaginationLoading = Rx(false);

  List<OrderItem> get orderItems => _orderItems.value;
  set orderItems(List<OrderItem> value) => _orderItems
    ..firstRebuild = true
    ..value = value;

  bool get isPaginationLoading => _isPaginationLoading.value;
  set isPaginationLoading(bool value) => _isPaginationLoading
    .value = value;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(onLazyLoad);
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    await onReadyGeneric(() async {
      await _getOrders();
    });
  }

  @override
  void onClose() {
    super.onClose();
    scrollController.dispose();
  }

  Future<void> _getOrders() async {
    final request = OrderHistoryRequestModel(
      pageIndex: transactionsResponse.index == null
          ? 0
          : transactionsResponse.index! + 1,
      pageSize: 5,
      id: sessionHandler.currentUser!.currentAccountId!,
    );

    await client.appService.orderHistory(request: request).handleRequest(
      onSuccess: (res) {
        transactionsResponse = res!;
        for (final item in res.items!) {
          orderItems.add(item);
        }
        orderItems = orderItems;
      },
    );
  }

  Future<void> onLazyLoad() async {
    if (!isPaginationLoading &&
        scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange &&
        (transactionsResponse.hasNext!)) {
      isPaginationLoading = true;
      await _getOrders();
      isPaginationLoading = false;
    }
  }

    void onTapOrderHistoryDetail(int id) =>
      context.pushNamed(
        SubRouteEnums.orderHistoryDetail.name,
        pathParameters: {'id': id.toString(),},
      );

}
