// ignore_for_file: lines_longer_than_80_chars

import 'dart:io';

import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kota_app/product/managers/cart_controller.dart';
import 'package:kota_app/product/models/cart_product_model.dart';
import 'package:kota_app/product/utility/enums/module_padding_enums.dart';
import 'package:kota_app/product/utility/enums/module_radius_enums.dart';
import 'package:kota_app/product/utility/extentions/num_extension.dart';
import 'package:kota_app/product/widgets/button/module_button.dart';
import 'package:kota_app/product/widgets/card/bordered_image.dart';
import 'package:kota_app/product/widgets/other/empty_view.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:values/values.dart';

part 'components/product_card.dart';

class Cart extends StatefulWidget {
  const Cart({super.key});

  @override
  State<Cart> createState() => _CartState();
}

class _CartState extends State<Cart> {
  final ScrollController _scrollController = ScrollController();
  bool _showScrollButton = false;
  

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(() {
      final maxScroll = _scrollController.position.maxScrollExtent;
      final currentScroll = _scrollController.offset;
      final showButton =
          currentScroll > 200 && (maxScroll - currentScroll) > 20;

      if (showButton != _showScrollButton) {
        setState(() {
          _showScrollButton = showButton;
        });
      }
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    _scrollController.animateTo(
      _scrollController.position.maxScrollExtent,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> _showClearCartDialog(
    BuildContext context,
    CartController controller,
  ) async {
    final labels = AppLocalization.getLabels(context);
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Text(
            labels.clearCart,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          content: Text(
            labels.clearCartConfirmation,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                labels.cancel,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(
                labels.clear,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.error,
                  fontWeight: FontWeight.bold,
                ),
              ),
              onPressed: () {
                controller.clearCart();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  Future<void> _generateAndOpenPdf(
    BuildContext context,
    List<CartProductModel> products,
    CartController controller
  ) async {
    final labels = AppLocalization.getLabels(context);
    if (products.isEmpty) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(labels.noDataToReport)),
        );
      }
      return;
    }

    final pdf = pw.Document();
    const baseAssetPath = 'assets/fonts/work_sans/';

    try {
      final ttfRegular =
          await rootBundle.load('${baseAssetPath}WorkSans-Regular.ttf');
      final ttf = pw.Font.ttf(ttfRegular);

      // Group products by productCodeGroupId
      final groupedProducts = <int?, List<CartProductModel>>{};
      for (final product in products) {
        if (!groupedProducts.containsKey(product.productCodeGroupId)) {
          groupedProducts[product.productCodeGroupId] = [];
        }
        groupedProducts[product.productCodeGroupId]!.add(product);
      }

      final columnWidths = {
        0: const pw.FlexColumnWidth(4), // Product Name
        1: const pw.FlexColumnWidth(1.6), // Code
        2: const pw.FlexColumnWidth(1.2), // Size
        3: const pw.FlexColumnWidth(1.5), // Color
        4: const pw.FlexColumnWidth(), // Quantity
        5: const pw.FlexColumnWidth(1.2), // Price
        6: const pw.FlexColumnWidth(1.5), // Total
      };

      final headers = [
        labels.productName,
        labels.code,
        labels.size,
        labels.color,
        labels.quantity,
        labels.price,
        labels.total,
      ];

      final headerRow = pw.TableRow(
        decoration: const pw.BoxDecoration(
          color: PdfColors.blue900,
          borderRadius: pw.BorderRadius.vertical(top: pw.Radius.circular(4)),
        ),
        children: headers
            .map(
              (header) => pw.Padding(
                padding:
                    const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: pw.Text(
                  header,
                  style: pw.TextStyle(
                    font: ttf,
                    fontWeight: pw.FontWeight.bold,
                    color: PdfColors.white,
                  ),
                ),
              ),
            )
            .toList(),
      );

      final allRows = groupedProducts.entries.expand((entry) {
        final isEvenGroup =
            groupedProducts.keys.toList().indexOf(entry.key) % 2 == 0;
        return entry.value.map(
          (product) => pw.TableRow(
            decoration: pw.BoxDecoration(
              color: isEvenGroup ? PdfColors.white : PdfColors.grey400,
            ),
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(2),
                child: pw.Text(
                  product.name ?? '',
                  style: pw.TextStyle(font: ttf),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(2),
                child: pw.Text(product.code, style: pw.TextStyle(font: ttf)),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(2),
                child: pw.Text(
                  product.sizeName ?? '-',
                  style: pw.TextStyle(font: ttf),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(2),
                child: pw.Text(
                  product.colorName ?? '-',
                  style: pw.TextStyle(font: ttf),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(2),
                child: pw.Text(
                  product.quantity.toString(),
                  style: pw.TextStyle(font: ttf),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(2),
                child: pw.Text(
                  controller.isCurrencyTL
                      ? product.price.formatPrice()
                      : product.currencyUnitPrice!.formatPrice(),
                  style: pw.TextStyle(font: ttf),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(2),
                child: pw.Text(
                  controller.isCurrencyTL
                      ? (product.price * product.quantity).formatPrice()
                      : (product.currencyUnitPrice! * product.quantity)
                          .formatPrice(),
                  style: pw.TextStyle(font: ttf),
                ),
              ),
            ],
          ),
        );
      }).toList();

      pdf.addPage(
        pw.MultiPage(
          pageFormat: PdfPageFormat.a4.copyWith(
            marginLeft: 30,
            marginRight: 30,
            marginTop: 40,
            marginBottom: 40,
          ),
          header: (context) => pw.Text(
            '${labels.cartProducts} - ${labels.page} ${context.pageNumber}',
            style: pw.TextStyle(
              font: ttf,
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          footer: (context) {
            if (context.pageNumber == context.pagesCount) {
              final totalQuantity = products.fold<int>(
                0,
                (sum, product) => sum + product.quantity,
              );
              final totalPrice = products.fold<double>(
                0,
                (sum, product) => sum + (controller.isCurrencyTL
                    ? product.price * product.quantity
                    : product.currencyUnitPrice! * product.quantity),
              );

              return pw.Container(
                decoration: pw.BoxDecoration(
                  color: PdfColors.grey100,
                  borderRadius:
                      const pw.BorderRadius.all(pw.Radius.circular(4)),
                  border: pw.Border.all(color: PdfColors.grey400),
                ),
                padding: const pw.EdgeInsets.all(10),
                margin: const pw.EdgeInsets.only(top: 20),
                child: pw.Row(
                  mainAxisAlignment: pw.MainAxisAlignment.end,
                  children: [
                    pw.Column(
                      crossAxisAlignment: pw.CrossAxisAlignment.end,
                      children: [
                        pw.Row(
                          children: [
                            pw.Text(
                              '${labels.totalQuantity}: ',
                              style: pw.TextStyle(
                                font: ttf,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.blue900,
                              ),
                            ),
                            pw.Text(
                              totalQuantity.toString(),
                              style: pw.TextStyle(
                                font: ttf,
                                fontWeight: pw.FontWeight.bold,
                                color: PdfColors.blue900,
                              ),
                            ),
                          ],
                        ),
                        pw.SizedBox(height: 8),
                        pw.Row(
                          children: [
                            pw.Text(
                              '${labels.totalAmount}: ',
                              style: pw.TextStyle(
                                font: ttf,
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 14,
                                color: PdfColors.blue900,
                              ),
                            ),
                            pw.Text(
                              totalPrice.formatPrice(),
                              style: pw.TextStyle(
                                font: ttf,
                                fontWeight: pw.FontWeight.bold,
                                fontSize: 14,
                                color: PdfColors.blue900,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              );
            }
            return pw.Container();
          },
          build: (context) => [
            pw.SizedBox(height: 10),
            pw.Table(
              border: pw.TableBorder.all(
                color: PdfColors.grey400,
                width: 0.5,
              ),
              columnWidths: columnWidths,
              children: [
                headerRow,
                ...allRows,
              ],
            ),
          ],
        ),
      );

      final output = await getTemporaryDirectory();
      final file = File('${output.path}/sepet_urunleri.pdf');
      await file.writeAsBytes(await pdf.save());
      await OpenFile.open(file.path);
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('PDF oluşturulurken bir hata oluştu: $e')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final labels = AppLocalization.getLabels(context);

    return GetBuilder<CartController>(
      builder: (controller) {
        return Scaffold(
          key: controller.scaffoldKey,
          appBar: AppBar(
            title: Text(labels.cart),
            actions: [
              if (controller.itemList.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.picture_as_pdf),
                  onPressed: () =>
                      _generateAndOpenPdf(context, controller.itemList, controller),
                ),
              Obx(
                () => controller.itemList.isNotEmpty
                    ? IconButton(
                        icon: const Icon(Icons.delete_outline),
                        onPressed: () =>
                            _showClearCartDialog(context, controller),
                      )
                    : const SizedBox(),
              ),
            ],
          ),
          floatingActionButtonLocation:
              FloatingActionButtonLocation.miniCenterDocked,
          floatingActionButton: Obx(
            () => AnimatedSlide(
              duration: const Duration(milliseconds: 300),
              offset: controller.itemList.isEmpty
                  ? const Offset(0, 2)
                  : Offset.zero,
              child: AnimatedOpacity(
                duration: const Duration(milliseconds: 300),
                opacity: controller.itemList.isEmpty ? 0 : 1,
                child: Padding(
                  padding: EdgeInsets.all(ModulePadding.s.value),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Container(
                        padding: EdgeInsets.only(
                          left: ModulePadding.s.value,
                          right: ModulePadding.s.value,
                          top: ModulePadding.s.value,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context).cardColor,
                          borderRadius:
                              BorderRadius.circular(ModuleRadius.m.value),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 10,
                              offset: const Offset(0, -5),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  labels.totalAmount,
                                  style: context.titleMedium,
                                ),
                                Obx(
                                  () => Text(
                                    controller.totalAmount().formatPrice(),
                                    style: context.headlineSmall.copyWith(
                                      fontWeight: FontWeight.bold,
                                      color: Theme.of(context).primaryColor,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: ModulePadding.xxs.value),
                            Obx(
                              () => Column(
                                children: [
                                  Row(
                                    children: [
                                      Icon(
                                        Icons.note_add_outlined,
                                        color: Theme.of(context).primaryColor,
                                      ),
                                      SizedBox(width: ModulePadding.xs.value),
                                      Text(
                                        labels.orderNote,
                                        style: context.titleSmall,
                                      ),
                                      const Spacer(),
                                      IconButton(
                                        onPressed: controller
                                            .isDescriptionVisible.toggle,
                                        icon: Icon(
                                          controller.isDescriptionVisible.value
                                              ? Icons.keyboard_arrow_up
                                              : Icons.keyboard_arrow_down,
                                        ),
                                      ),
                                    ],
                                  ),
                                  if (controller
                                      .isDescriptionVisible.value) ...[
                                    SizedBox(height: ModulePadding.xs.value),
                                    TextField(
                                      controller:
                                          controller.descriptionController,
                                      decoration: InputDecoration(
                                        hintText: labels.addOrderNote,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            ModuleRadius.s.value,
                                          ),
                                        ),
                                      ),
                                      maxLines: 3,
                                    ),
                                    SizedBox(height: ModulePadding.s.value),
                                  ],
                                ],
                              ),
                            ),
                            SizedBox(
                              width: double.infinity,
                              height: 54,
                              child: ModuleButton.primary(
                                onTap: () => controller.completeOrder(context),
                                title: controller.editingOrderId?.value != 0
                                    ? labels.updateOrder
                                    : labels.completeOrder,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
          body: Stack(
            children: [
              Obx(
                () => CustomScrollView(
                  controller: _scrollController,
                  slivers: [
                    SliverToBoxAdapter(
                      child: AnimatedSwitcher(
                        duration: const Duration(milliseconds: 300),
                        child: controller.itemList.isEmpty
                            ? EmptyView(
                                message: labels.emptyCartMessage,
                              )
                            : Padding(
                                padding: EdgeInsets.all(ModulePadding.s.value),
                                child: ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  padding: const EdgeInsets.only(
                                    bottom:
                                        180, // Add padding for the complete order section
                                  ),
                                  itemBuilder: (context, index) {
                                    final item = controller.itemList[index];
                                    return Dismissible(
                                      key: Key(item.id.toString()),
                                      direction: DismissDirection.endToStart,
                                      background: Container(
                                        alignment: Alignment.centerRight,
                                        padding: EdgeInsets.only(
                                          right: ModulePadding.m.value,
                                        ),
                                        color: Colors.red,
                                        child: const Icon(
                                          Icons.delete_outline,
                                          color: Colors.white,
                                        ),
                                      ),
                                      onDismissed: (_) =>
                                          controller.onTapRemoveProduct(item),
                                      child: _ProductCard(
                                        item: item,
                                        onTapRemove: () =>
                                            controller.onTapRemoveProduct(item),
                                        isCurrencyTL: controller.isCurrencyTL,
                                      ),
                                    );
                                  },
                                  separatorBuilder: (_, __) => SizedBox(
                                    height: ModulePadding.s.value,
                                  ),
                                  itemCount: controller.itemList.length,
                                ),
                              ),
                      ),
                    ),
                  ],
                ),
              ),
              if (_showScrollButton)
                Positioned(
                  right: ModulePadding.m.value,
                  bottom: ModulePadding.m.value + 180,
                  child: FloatingActionButton(
                    mini: true,
                    onPressed: _scrollToTop,
                    child: const Icon(Icons.keyboard_arrow_up),
                  ),
                ),
              if (_showScrollButton)
                Positioned(
                  right: ModulePadding.m.value,
                  bottom: ModulePadding.m.value,
                  child: FloatingActionButton(
                    mini: true,
                    onPressed: _scrollToBottom,
                    child: const Icon(Icons.keyboard_arrow_down),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}
