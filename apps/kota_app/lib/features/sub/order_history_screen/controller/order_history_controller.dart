import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:kota_app/features/sub/order_history_detail_screen/order_pdf/order_pdf_controller.dart';
import 'package:kota_app/product/base/controller/base_controller.dart';
import 'package:kota_app/product/managers/cart_controller.dart';
import 'package:kota_app/product/models/cart_product_model.dart';
import 'package:kota_app/product/navigation/modules/bottom_navigation_route/bottom_navigation_route_enums.dart';
import 'package:kota_app/product/navigation/modules/sub_route/sub_route_enums.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:widgets/widget.dart';

class OrderHistoryController extends BaseControllerInterface {
  OrdersHistoryResponseModel transactionsResponse =
      OrdersHistoryResponseModel();

  final ScrollController scrollController = ScrollController();

  final Rx<List<OrderItem>> _orderItems = Rx([]);
  final Rx<bool> _isPaginationLoading = Rx(false);
  final OrderPdfController invoicePdfController = Get.put(OrderPdfController());

  List<OrderItem> get orderItems => _orderItems.value;
  set orderItems(List<OrderItem> value) => _orderItems
    ..firstRebuild = true
    ..value = value;

  bool get isPaginationLoading => _isPaginationLoading.value;
  set isPaginationLoading(bool value) => _isPaginationLoading.value = value;

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

  void onTapOrderHistoryDetail(int id) => context.pushNamed(
        SubRouteEnums.orderHistoryDetail.name,
        pathParameters: {
          'id': id.toString(),
        },
      );

  Future<void> onTapDeleteOrderHistory(int id) async {
    LoadingProgress.start();
    await client.appService.deleteOrder(id: id).handleRequest(
      ignoreException: true,
      onIgnoreException: (err) {
        showErrorToastMessage(err?.title ?? 'Bir hata oluştu.');
      },
      onSuccess: (res) {
        showSuccessToastMessage('Sipariş başarıyla silindi.');
        orderItems = [];
        transactionsResponse = OrdersHistoryResponseModel();
        onReady();
      },
      defaultResponse: OrdersHistoryDetailResponseModel(),
    );
    LoadingProgress.stop();
  }

  Future<void> onTapOrderPdfCard(int id) async {
    await client.appService.orderHistoryDetail(id: id).handleRequest(
      onSuccess: (res) async {
        final cartProductItems = <CartProductModel>[];

        for (final item in res!.items!) {
          cartProductItems.add(
            CartProductModel(
              id: item.id!,
              code: item.code!,
              price: item.birimFiyat!,
              quantity: item.miktar!,
              name: item.name,
            ),
          );
        }

        final pdfModel = CartProductPdfModel(
          id: res.id,
          code: res.kod,
          date: res.tarih,
          items: cartProductItems,
          totalPrice: res.toplamTutar,
        );

        final pdf =
            await invoicePdfController.generateOrderHistoryDetailPdf(pdfModel);
        await Printing.layoutPdf(
          onLayout: (PdfPageFormat format) async => pdf.save(),
        );
      },
    );
  }

  Future<void> onTapEditOrder(int id) async {
    final cartController = Get.find<CartController>();
    await cartController.clearCart();
    cartController.editingOrderId?.value = id;

    await client.appService.orderHistoryDetail(id: id).handleRequest(
      onSuccess: (res) {
        for (final item in res!.items!) {
          final cartItem = CartProductModel(
            id: item.urunId!,
            code: item.code!,
            price: item.birimFiyat!,
            quantity: item.miktar!,
            name: item.name,
            pictureUrl: item.pictureUrl,
            orderDetailId: item.id,
            sizeName: item.sizeName,
            colorName: item.colorName,
            productCodeGroupId: item.productCodeGroupId,
          );
          cartController.onTapAddProduct(cartItem);
        }
      },
    );

    context.goNamed(BottomNavigationRouteEnum.cartScreen.name);
  }
}
