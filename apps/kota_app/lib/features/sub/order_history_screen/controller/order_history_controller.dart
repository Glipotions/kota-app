import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:kota_app/features/navigation/bottom_navigation_bar/controller/bottom_navigation_controller.dart';
import 'package:kota_app/features/sub/active_orders_screen/active_orders_pdf_controller.dart';
import 'package:kota_app/features/sub/order_history_detail_screen/order_pdf/order_pdf_controller.dart';
import 'package:kota_app/product/base/controller/base_controller.dart';
import 'package:kota_app/product/managers/cart_controller.dart';
import 'package:kota_app/product/models/cart_product_model.dart';
import 'package:kota_app/product/navigation/modules/bottom_navigation_route/bottom_navigation_route_enums.dart';
import 'package:kota_app/product/navigation/modules/sub_route/sub_route_enums.dart';
import 'package:kota_app/product/utility/enums/currency_type.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:widgets/widget.dart';

class OrderHistoryController extends BaseControllerInterface {
  OrdersHistoryResponseModel transactionsResponse =
      OrdersHistoryResponseModel();

  final ScrollController scrollController = ScrollController();

  final Rx<List<OrderItem>> _orderItems = Rx([]);
  final Rx<bool> _isPaginationLoading = Rx(false);
  final Rx<List<AlinanSiparisBilgileriL>> _activeOrders = Rx([]);
  final Rx<bool> _isActiveOrdersLoading = Rx(false);

  final OrderPdfController invoicePdfController = Get.put(OrderPdfController());
  final ActiveOrdersPdfController activeOrdersPdfController =
      Get.put(ActiveOrdersPdfController());
  final BottomNavigationController bottomNavController =
      Get.find<BottomNavigationController>();

  List<OrderItem> get orderItems => _orderItems.value;
  set orderItems(List<OrderItem> value) => _orderItems
    ..firstRebuild = true
    ..value = value;

  List<AlinanSiparisBilgileriL> get activeOrders => _activeOrders.value;
  set activeOrders(List<AlinanSiparisBilgileriL> value) => _activeOrders
    ..firstRebuild = true
    ..value = value;

  bool get isPaginationLoading => _isPaginationLoading.value;
  set isPaginationLoading(bool value) => _isPaginationLoading.value = value;

  bool get isActiveOrdersLoading => _isActiveOrdersLoading.value;
  set isActiveOrdersLoading(bool value) => _isActiveOrdersLoading.value = value;

  // Currency related cached value
  late final Rx<int> _currencyType = 1.obs;
  late final Rx<bool> _isCurrencyTL = true.obs;

  int get currencyType => _currencyType.value;
  bool get isCurrencyTL => _isCurrencyTL.value;

  int? _currentAccountId;

  void _updateCurrencyValues() {
    _currencyType.value = sessionHandler.currentUser?.currencyType ?? 1;
    _isCurrencyTL.value =
        CurrencyType.tl == CurrencyType.fromValue(_currencyType.value);
  }

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(onLazyLoad);
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    await onReadyGeneric(() async {
      _updateCurrencyValues();
      await _getOrders();
    });
  }

  @override
  void onClose() {
    super.onClose();
    scrollController.dispose();
  }

  Future<void> _getOrders([int? id]) async {
    final request = OrderHistoryRequestModel(
      pageIndex: transactionsResponse.index == null
          ? 0
          : transactionsResponse.index! + 1,
      pageSize: 10,
      id: id ?? sessionHandler.currentUser!.currentAccountId!,
      connectedBranchCurrentInfoId:
          sessionHandler.currentUser!.connectedBranchCurrentInfoId,
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
      await _getOrders(_currentAccountId);
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

  Future<void> onTapOrderPdfCard(int id, bool isCurrencyTL) async {
    await client.appService.orderHistoryDetail(id: id).handleRequest(
      onSuccess: (res) async {
        final cartProductItems = <CartProductModel>[];

        for (final item in res!.items!) {
          cartProductItems.add(
            CartProductModel(
              id: item.id!,
              code: item.code!,
              price: isCurrencyTL ? item.birimFiyat! : item.dovizliBirimFiyat!,
              quantity: item.miktar!,
              name: item.name,
              pictureUrl: item.pictureUrl,
              // Include discount rate if available from order level
              discountRate: res.iskontoOrani ?? 0,
            ),
          );
        }

        final pdfModel = CartProductPdfModel(
          id: res.id,
          code: res.kod,
          date: res.tarih,
          items: cartProductItems,
          totalPrice: isCurrencyTL ? res.toplamTutar : res.dovizTutar,
          description: res.aciklama,
        );

        final pdf = await invoicePdfController.generateOrderHistoryDetailPdf(
            pdfModel, context);
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
        // Set the general discount rate from the order FIRST
        if (res!.iskontoOrani != null && res.iskontoOrani! > 0) {
          cartController.cartDiscountRate.value = res.iskontoOrani!;
          // Also update the discount controller text field
          cartController.discountController.text = res.iskontoOrani!.toStringAsFixed(2);
        } else {
          // Reset discount if no discount in order
          cartController.cartDiscountRate.value = 0;
          cartController.discountController.text = '';
        }

        for (final item in res.items!) {
          final cartItem = CartProductModel(
            id: item.urunId!,
            code: item.code!,
            price: item.birimFiyat!,
            currencyUnitPrice: item.dovizliBirimFiyat,
            quantity: item.miktar!,
            name: item.name,
            pictureUrl: item.pictureUrl,
            orderDetailId: item.id,
            sizeName: item.sizeName,
            colorName: item.colorName,
            productCodeGroupId: item.productCodeGroupId,
            // Set discount rate from order level
            discountRate: res.iskontoOrani ?? 0,
          );
          cartController.onTapAddProduct(cartItem);
        }

        // Clean description from existing discount text before setting
        String cleanDescription = res.aciklama ?? '';
        cleanDescription = _removeExistingDiscountText(cleanDescription);
        cartController.descriptionController.text = cleanDescription;
      },
    );

    context.goNamed(BottomNavigationRouteEnum.cartScreen.name);
    bottomNavController.selectedIndex = 1;
  }

  /// Removes existing discount text from description to prevent duplication
  String _removeExistingDiscountText(String description) {
    // Remove patterns like "(İskonto: %10.00)" or "(İskonto %10.00)"
    final discountPattern = RegExp(r'\s*\(İskonto:?\s*%[\d.,]+\)');
    return description.replaceAll(discountPattern, '').trim();
  }

  Future<void> onCurrentAccountSelected(GetCurrentAccount account) async {
    // sessionHandler.currentUser?.currentAccountId = account.id;
    orderItems.clear();
    transactionsResponse = OrdersHistoryResponseModel();
    _currentAccountId = account.id;
    await _getOrders(account.id);
  }

  /// Fetches active orders for the current account
  Future<void> getActiveOrders() async {
    isActiveOrdersLoading = true;
    final currentAccountId =
        _currentAccountId ?? sessionHandler.currentUser!.currentAccountId!;

    await client.appService
        .getActiveOrders(
          id: currentAccountId,
          branchCurrentInfoId:
              sessionHandler.currentUser!.connectedBranchCurrentInfoId,
        )
        .handleRequest(
          onSuccess: (res) {
            if (res?.items != null) {
              activeOrders = res!.items!;
            } else {
              activeOrders = [];
            }
          },
          ignoreException: true,
          onIgnoreException: (error) {
            showErrorToastMessage(
                'Aktif siparişler alınırken bir hata oluştu.');
            activeOrders = [];
          },
          defaultResponse: ActiveOrdersResponseModel(items: []),
        );

    isActiveOrdersLoading = false;
  }

  /// Shows active orders in a dialog
  Future<void> showActiveOrders(BuildContext context) async {
    // LoadingProgress and getActiveOrders are removed as the
    // new screen's controller handles its own loading and data fetching.
    // LoadingProgress.start();
    // await getActiveOrders();
    // LoadingProgress.stop();

    // Navigate to the new ActiveOrdersScreen using GetX navigation
    // Make sure to define the '/active-orders' route in your GetX pages/routes configuration.
    await context.pushNamed(SubRouteEnums.activeOrders.name);

    /* Old dialog code removed:
    if (context.mounted) {
      await showDialog<void>(
        context: context,
        builder: (context) => ActiveOrdersDialog(
          activeOrders: activeOrders,
          isCurrencyTL: isCurrencyTL,
        ),
      );
    }
    */
  }

  /// Generates PDF for active orders
  Future<void> generateActiveOrdersPdf(BuildContext context) async {
    if (activeOrders.isEmpty) {
      showErrorToastMessage('Aktif sipariş bulunamadı.');
      return;
    }

    final pdf = await activeOrdersPdfController.generateActiveOrdersPdf(
      activeOrders,
      context,
      isCurrencyTL,
    );

    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdf.save(),
    );
  }
}
