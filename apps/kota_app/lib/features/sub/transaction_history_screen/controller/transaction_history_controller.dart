import 'package:api/api.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kota_app/product/base/controller/base_controller.dart';
import 'package:kota_app/product/utility/enums/currency_type.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

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
  int get currencyType => sessionHandler.currentUser?.currencyType ?? 1;
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
      if (CurrencyType.fromValue(currencyType) == CurrencyType.tl) {
        if (item.alacak != null && item.alacak! > 0) {
          income += item.alacak!;
        }
        if (item.borc != null && item.borc! > 0) {
          expense += item.borc!;
        }
      } else {
        if (item.dovizAlacak != null && item.dovizAlacak! > 0) {
          income += item.dovizAlacak!;
        }
        if (item.dovizBorc != null && item.dovizBorc! > 0) {
          expense += item.dovizBorc!;
        }
      }
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

  Future<void> generatePdfReport(BuildContext context, String currentAccountName,
      List<TransactionItem> transactions, bool isDoviz) async {
    final labels = AppLocalization.getLabels(context);
    
    if (transactions.isEmpty) {
      if (scaffoldKey.currentContext != null) {
        ScaffoldMessenger.of(scaffoldKey.currentContext!).showSnackBar(
          SnackBar(
            content: Text(labels.noDataToReport),
            duration: const Duration(seconds: 2),
          ),
        );
      }
      return;
    }

    final pdf = pw.Document();
    const baseAssetPath = 'assets/fonts/greycliffcf/';

    try {
      // Fontları yükleme
      final fontDataRegular =
          await rootBundle.load('${baseAssetPath}GreycliffCF-Regular.ttf');
      final fontDataBold =
          await rootBundle.load('${baseAssetPath}GreycliffCF-Bold.ttf');

      final ttfRegular = pw.Font.ttf(fontDataRegular.buffer.asByteData());
      final ttfBold = pw.Font.ttf(fontDataBold.buffer.asByteData());

      final numberFormat = NumberFormat('#,##0.00', 'tr_TR');
      final date = DateTime.now();

      // Column Widths
      final columnWidths = <int, pw.TableColumnWidth>{
        0: const pw.FlexColumnWidth(1.25),
        1: const pw.FlexColumnWidth(1.5),
        2: const pw.FlexColumnWidth(2.5),
        3: const pw.FlexColumnWidth(3.35),
        4: const pw.FlexColumnWidth(1.25),
        5: const pw.FlexColumnWidth(1.25),
        6: const pw.FlexColumnWidth(1.30),
      };

      // Tablo için başlık satırları
      final headers = isDoviz
          ? [
              labels.date,
              labels.receiptNo,
              labels.receiptType,
              labels.description,
              labels.foreignDebit,
              labels.foreignCredit,
              labels.foreignBalance
            ]
          : [
              labels.date,
              labels.receiptNo,
              labels.receiptType,
              labels.description,
              labels.debit,
              labels.credit,
              labels.balance
            ];

      // Sayfa ekleme
      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4,
          margin: const pw.EdgeInsets.all(20),
          maxPages: 30,
          build: (pw.Context context) => [
            pw.Header(
              level: 0,
              child: pw.Column(
                children: [
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text('${labels.current} : $currentAccountName',
                              style: pw.TextStyle(font: ttfBold, fontSize: 12)),
                          pw.Text('${labels.period} : ${date.year}',
                              style: pw.TextStyle(font: ttfBold, fontSize: 12)),
                        ],
                      ),
                      pw.Text('${labels.date} = ${date.day}.${date.month}.${date.year}',
                          style: pw.TextStyle(font: ttfBold, fontSize: 12)),
                    ],
                  ),
                ],
              ),
            ),
            pw.SizedBox(height: 10),

            // Tablo Başlıkları
            pw.Table(
              border: pw.TableBorder.all(),
              columnWidths: columnWidths,
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(color: PdfColors.grey300),
                  children: headers
                      .map((header) => pw.Padding(
                            padding: const pw.EdgeInsets.all(5),
                            child: pw.Text(
                              header,
                              style: pw.TextStyle(font: ttfBold, fontSize: 10),
                              textAlign: pw.TextAlign.center,
                            ),
                          ))
                      .toList(),
                ),
              ],
            ),
            // Tablo Satırları
            pw.Table(
              border: pw.TableBorder.all(),
              columnWidths: columnWidths,
              children: transactions.map((tx) {
                final isHighlighted =
                    (isDoviz ? tx.dovizAlacak : tx.alacak) != null &&
                        (isDoviz ? tx.dovizAlacak : tx.alacak)! > 0;

                return pw.TableRow(
                  decoration: isHighlighted
                      ? const pw.BoxDecoration(color: PdfColors.pink100)
                      : null,
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(
                        tx.tarih != null
                            ? '${tx.tarih!.day}/${tx.tarih!.month}/${tx.tarih!.year}'
                            : '',
                        style: pw.TextStyle(font: ttfRegular, fontSize: 9),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(tx.fisNo ?? '',
                          style: pw.TextStyle(font: ttfRegular, fontSize: 9)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(tx.fisTuru ?? '',
                          style: pw.TextStyle(font: ttfRegular, fontSize: 9)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(tx.aciklama ?? '',
                          style: pw.TextStyle(font: ttfRegular, fontSize: 9)),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(
                        isDoviz
                            ? (tx.dovizBorc != null
                                ? numberFormat.format(tx.dovizBorc)
                                : '0,00')
                            : (tx.borc != null
                                ? numberFormat.format(tx.borc)
                                : '0,00'),
                        style: pw.TextStyle(font: ttfRegular, fontSize: 9),
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(
                        isDoviz
                            ? (tx.dovizAlacak != null
                                ? numberFormat.format(tx.dovizAlacak)
                                : '0,00')
                            : (tx.alacak != null
                                ? numberFormat.format(tx.alacak)
                                : '0,00'),
                        style: pw.TextStyle(font: ttfRegular, fontSize: 9),
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.all(5),
                      child: pw.Text(
                        isDoviz
                            ? (tx.dovizBakiye != null
                                ? numberFormat.format(tx.dovizBakiye)
                                : '0,00')
                            : (tx.bakiye != null
                                ? numberFormat.format(tx.bakiye)
                                : '0,00'),
                        style: pw.TextStyle(font: ttfRegular, fontSize: 9),
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                  ],
                );
              }).toList(),
            ),
          ],
        ),
      );

      // PDF'i kaydet ve kullanıcıya göster
      await Printing.layoutPdf(
        onLayout: (PdfPageFormat format) async => pdf.save(),
      );
    } catch (e) {
      // Hata durumunda kullanıcıya bildir
      Get.snackbar('Hata', 'PDF oluşturma hatası: $e',
          snackPosition: SnackPosition.BOTTOM);
    }
  }
}
