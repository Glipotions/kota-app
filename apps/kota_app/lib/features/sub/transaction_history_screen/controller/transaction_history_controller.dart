import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota_app/product/base/controller/base_controller.dart';
import 'package:intl/intl.dart';

class TransactionHistoryController extends BaseControllerInterface {
  // Data
  TransactionsHistoryResponseModel transactionsResponse =
      TransactionsHistoryResponseModel();
  final ScrollController scrollController = ScrollController();
  final TextEditingController searchController = TextEditingController();
  final DateFormat dateFormat = DateFormat('MMMM dd, yyyy');

  // Observable Variables
  final Rx<List<TransactionItem>> _transactionItems = Rx([]);
  final Rx<List<TransactionItem>> _filteredItems = Rx([]);
  final Rx<bool> _isPaginationLoading = Rx(false);
  final Rx<double> _currentBalance = Rx(0.0);
  final Rx<double> _totalIncome = Rx(0.0);
  final Rx<double> _totalExpense = Rx(0.0);
  final Rx<bool> _isDarkMode = Rx(false);

  // Getters and Setters
  List<TransactionItem> get transactionItems => _filteredItems.value;
  bool get isPaginationLoading => _isPaginationLoading.value;
  double get currentBalance => _currentBalance.value;
  double get totalIncome => _totalIncome.value;
  double get totalExpense => _totalExpense.value;
  bool get isDarkMode => _isDarkMode.value;

  set transactionItems(List<TransactionItem> value) {
    _transactionItems.value = value;
    _updateFilteredItems();
    _updateSummary();
  }

  set isPaginationLoading(bool value) => _isPaginationLoading.value = value;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(onLazyLoad);
    searchController.addListener(() => _updateFilteredItems());
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
    searchController.dispose();
  }

  Future<void> _getTransactions() async {
    final request = TransactionsHistoryRequestModel(
      pageIndex: transactionsResponse.index == null
          ? 0
          : transactionsResponse.index! + 1,
      pageSize: 10,
      id: sessionHandler.currentUser!.currentAccountId!,
      connectedBranchCurrentInfoId:
          sessionHandler.currentUser!.connectedBranchCurrentInfoId,
    );

    await client.appService.transactionHistory(request: request).handleRequest(
      onSuccess: (res) {
        transactionsResponse = res!;
        final newItems = [..._transactionItems.value, ...res.items!];
        transactionItems = newItems;
      },
    );
  }

  void _updateSummary() {
    double income = 0;
    double expense = 0;

    for (final item in _transactionItems.value) {
      if (item.alacak != null && item.alacak! > 0) {
        income += item.alacak!;
      }
      if (item.borc != null && item.borc! > 0) {
        expense += item.borc!;
      }
      // if (item.bakiye != null) {
      //   balance = item.bakiye!;
      // }
    }

    _totalIncome.value = income;
    _totalExpense.value = expense;
    _currentBalance.value = expense - income;
  }

  void _updateFilteredItems() {
    final query = searchController.text.toLowerCase();
    if (query.isEmpty) {
      _filteredItems.value = _transactionItems.value;
      return;
    }

    _filteredItems.value = _transactionItems.value.where((item) {
      return (item.fisTuru?.toLowerCase().contains(query) ?? false) ||
          (item.fisNo?.toLowerCase().contains(query) ?? false);
    }).toList();
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

  void onSearchChanged(String value) {
    _updateFilteredItems();
  }

  bool shouldShowDateHeader(int index) {
    if (index == 0) return true;
    final currentDate = transactionItems[index].tarih;
    final previousDate = transactionItems[index - 1].tarih;
    
    if (currentDate == null || previousDate == null) return false;
    
    return !isSameDay(currentDate, previousDate);
  }

  String getDateHeader(int index) {
    final date = transactionItems[index].tarih;
    if (date == null) return '';
    return dateFormat.format(date);
  }

  bool isSameDay(DateTime date1, DateTime date2) {
    return date1.year == date2.year &&
        date1.month == date2.month &&
        date1.day == date2.day;
  }

  void showFilterDialog() {
    if (!Get.isDialogOpen!) {
      Get.dialog(
        barrierDismissible: true,
        AlertDialog(
          title: const Text('Filtrele'),
          content: const Text('Gelecek olarak desteklenmektedir...'),
          actions: [
            TextButton(
              onPressed: () => Get.back(closeOverlays: true),
              child: const Text('Kapat'),
            ),
          ],
        ),
      );
    }
  }

  void toggleTheme() {
    _isDarkMode.value = !_isDarkMode.value;
    Get.changeThemeMode(_isDarkMode.value ? ThemeMode.dark : ThemeMode.light);
  }
}
