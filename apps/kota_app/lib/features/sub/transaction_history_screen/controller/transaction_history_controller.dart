import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota_app/product/base/controller/base_controller.dart';

class TransactionHistoryController extends BaseControllerInterface {
  TransactionsHistoryResponseModel transactionsResponse =
      TransactionsHistoryResponseModel();

  final ScrollController scrollController = ScrollController();

  final Rx<List<TransactionItem>> _transactionItems = Rx([]);
  final Rx<bool> _isPaginationLoading = Rx(false);

  List<TransactionItem> get transactionItems => _transactionItems.value;
  set transactionItems(List<TransactionItem> value) => _transactionItems
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
      await _getTransactions();
    });
  }

  @override
  void onClose() {
    super.onClose();
    scrollController.dispose();
  }

  Future<void> _getTransactions() async {
    final request = TransactionsHistoryRequestModel(
      pageIndex: transactionsResponse.index == null
          ? 0
          : transactionsResponse.index! + 1,
      pageSize: 5,
      id: sessionHandler.currentUser!.currentAccountId!,
    );

    await client.appService.transactionHistory(request: request).handleRequest(
      onSuccess: (res) {
        transactionsResponse = res!;
        for (final item in res.items!) {
          transactionItems.add(item);
        }
        transactionItems = transactionItems;
      },
    );
  }

  Future<void> onLazyLoad() async {
    if (!isPaginationLoading &&
        scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange &&
        (transactionsResponse.hasNext!)) {
      isPaginationLoading = true;
      await _getTransactions();
      isPaginationLoading = false;
    }
  }
}
