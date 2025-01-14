// ignore_for_file: lines_longer_than_80_chars

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:kota_app/product/managers/cart_controller.dart';
import 'package:kota_app/product/models/cart_product_model.dart';
import 'package:kota_app/product/utility/enums/module_padding_enums.dart';
import 'package:kota_app/product/utility/enums/module_radius_enums.dart';
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

  Future<void> _showClearCartDialog(
      BuildContext context, CartController controller) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Text(
            'Sepeti Temizle',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          content: Text(
            'Sepetteki tüm ürünleri silmek istediğinizden emin misiniz?',
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                'İptal',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(
                'Temizle',
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

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<CartController>();

    return GetBuilder<CartController>(
      builder: (controller) {
        return Scaffold(
          key: controller.scaffoldKey,
          appBar: AppBar(
            title: const Text('Sepetim'),
            actions: [
              if (controller.itemList.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.picture_as_pdf),
                  onPressed: () => _generateAndOpenPdf(controller.itemList),
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
                                  'Toplam Tutar:',
                                  style: context.titleMedium,
                                ),
                                Obx(
                                  () => Text(
                                    controller.totalAmount().formatPrice(),
                                    style: context.headlineSmall?.copyWith(
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
                                        'Sipariş Notu',
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
                                        hintText:
                                            'Siparişiniz için not ekleyin...',
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                              ModuleRadius.s.value),
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
                                onTap: controller.completeOrder,
                                title: controller.editingOrderId?.value != 0
                                    ? 'Sipariş Güncelle'
                                    : 'Siparişi Tamamla',
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
                            ? const EmptyView(
                                message:
                                    'Sepete ürün eklenmemiştir.\nSepete eklediğiniz bütün ürünler burada listelenecektir!',
                              )
                            : Padding(
                                padding: EdgeInsets.all(ModulePadding.s.value),
                                child: ListView.separated(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemBuilder: (context, index) {
                                    final item = controller.itemList[index];
                                    return Dismissible(
                                      key: Key(item.id.toString()),
                                      direction: DismissDirection.endToStart,
                                      background: Container(
                                        alignment: Alignment.centerRight,
                                        padding: EdgeInsets.only(
                                            right: ModulePadding.m.value),
                                        color: Colors.red,
                                        child: const Icon(
                                          Icons.delete_outline,
                                          color: Colors.white,
                                        ),
                                      ),
                                      confirmDismiss: (direction) async {
                                        return await showDialog(
                                          context: context,
                                          builder: (BuildContext context) {
                                            return AlertDialog(
                                              backgroundColor:
                                                  Theme.of(context).cardColor,
                                              title: Text(
                                                'Ürünü Sil',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .titleLarge
                                                    ?.copyWith(
                                                      color: Colors.red,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                              ),
                                              content: Text(
                                                'Ürünü sepetten silmek istediğinize emin misiniz?\n\n${item.name}',
                                                style: Theme.of(context)
                                                    .textTheme
                                                    .bodyMedium
                                                    ?.copyWith(
                                                      color: Theme.of(context)
                                                          .textTheme
                                                          .bodyLarge
                                                          ?.color,
                                                    ),
                                              ),
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(12),
                                              ),
                                              actions: <Widget>[
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(false),
                                                  style: TextButton.styleFrom(
                                                    foregroundColor:
                                                        Colors.grey[600],
                                                  ),
                                                  child: const Text('İptal'),
                                                ),
                                                TextButton(
                                                  onPressed: () =>
                                                      Navigator.of(context)
                                                          .pop(true),
                                                  style: TextButton.styleFrom(
                                                    foregroundColor: Colors.red,
                                                    backgroundColor: Colors.red
                                                        .withOpacity(0.1),
                                                    padding: const EdgeInsets
                                                        .symmetric(
                                                      horizontal: 16,
                                                      vertical: 8,
                                                    ),
                                                  ),
                                                  child: const Text(
                                                    'Sil',
                                                    style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold),
                                                  ),
                                                ),
                                              ],
                                            );
                                          },
                                        );
                                      },
                                      onDismissed: (direction) =>
                                          controller.onTapRemoveProduct(item),
                                      child: _ProductCard(
                                        item: item,
                                        onTapRemove: () =>
                                            controller.onTapRemoveProduct(item),
                                      ),
                                    );
                                  },
                                  separatorBuilder: (context, index) =>
                                      SizedBox(
                                    height: ModulePadding.xs.value,
                                  ),
                                  itemCount: controller.itemList.length,
                                ),
                              ),
                      ),
                    ),
                    // Add extra space at bottom for the floating action button
                    const SliverToBoxAdapter(
                      child: SizedBox(height: 160),
                    ),
                  ],
                ),
              ),
              if (_showScrollButton)
                Positioned(
                  right: ModulePadding.m.value,
                  bottom: 200,
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

  Future<void> _generateAndOpenPdf(List<CartProductModel> products) async {
    var pdf = pw.Document();

    // Group products by productCodeGroupId and sort them
    final groupedProducts = <int?, List<CartProductModel>>{};
    for (var product in products) {
      if (!groupedProducts.containsKey(product.productCodeGroupId)) {
        groupedProducts[product.productCodeGroupId] = [];
      }
      groupedProducts[product.productCodeGroupId]!.add(product);
    }
    const baseAssetPath = 'assets/fonts/work_sans/';

    // Get the font
    final ttfRegular =
        await rootBundle.load('${baseAssetPath}WorkSans-Regular.ttf');

    final ttf = pw.Font.ttf(ttfRegular);

    // Create table header
    pw.TableRow buildTableHeader(pw.Font ttf) => pw.TableRow(
          decoration: pw.BoxDecoration(
            color: PdfColors.blue900,
            borderRadius:
                const pw.BorderRadius.vertical(top: pw.Radius.circular(4)),
          ),
          children: [
            pw.Padding(
              padding:
                  const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: pw.Text(
                'Ürün Adı',
                style: pw.TextStyle(
                  font: ttf,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
            ),
            pw.Padding(
              padding:
                  const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: pw.Text(
                'Kod',
                style: pw.TextStyle(
                  font: ttf,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
            ),
            pw.Padding(
              padding:
                  const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: pw.Text(
                'Beden',
                style: pw.TextStyle(
                  font: ttf,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
            ),
            pw.Padding(
              padding:
                  const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: pw.Text(
                'Renk',
                style: pw.TextStyle(
                  font: ttf,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
            ),
            pw.Padding(
              padding:
                  const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: pw.Text(
                'Adet',
                style: pw.TextStyle(
                  font: ttf,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
            ),
            pw.Padding(
              padding:
                  const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: pw.Text(
                'Fiyat',
                style: pw.TextStyle(
                  font: ttf,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
            ),
            pw.Padding(
              padding:
                  const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 4),
              child: pw.Text(
                'Toplam',
                style: pw.TextStyle(
                  font: ttf,
                  fontWeight: pw.FontWeight.bold,
                  color: PdfColors.white,
                ),
              ),
            ),
          ],
        );

    // Footer widget'ı
    pw.Widget buildFooter(List<CartProductModel> products, pw.Font ttf) {
      final totalQuantity =
          products.fold<int>(0, (sum, product) => sum + product.quantity);
      final totalPrice = products.fold<double>(
          0, (sum, product) => sum + (product.price * product.quantity));

      return pw.Container(
        decoration: pw.BoxDecoration(
          color: PdfColors.grey100,
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
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
                      'Toplam Miktar: ',
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
                      'Toplam Tutar: ',
                      style: pw.TextStyle(
                        font: ttf,
                        fontWeight: pw.FontWeight.bold,
                        fontSize: 14,
                        color: PdfColors.blue900,
                      ),
                    ),
                    pw.Text(
                      totalPrice.toStringAsFixed(2),
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

    final allRows = groupedProducts.entries.expand((entry) {
      bool isEvenGroup =
          groupedProducts.keys.toList().indexOf(entry.key) % 2 == 0;
      return entry.value.map((product) => pw.TableRow(
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
                child: pw.Text(
                  product.code,
                  style: pw.TextStyle(font: ttf),
                ),
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
                  product.price.toStringAsFixed(2),
                  style: pw.TextStyle(font: ttf),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(2),
                child: pw.Text(
                  (product.price * product.quantity).toStringAsFixed(2),
                  style: pw.TextStyle(font: ttf),
                ),
              ),
            ],
          ));
    }).toList();

    // Her sayfada kaç ürün gösterileceğini belirle
    int rowsPerPage = 20;
    bool success = false;

    while (!success && rowsPerPage > 0) {
      pdf = pw.Document();
      try {
        for (var i = 0; i < allRows.length; i += rowsPerPage) {
          final endIndex = (i + rowsPerPage < allRows.length)
              ? i + rowsPerPage
              : allRows.length;
          final pageRows = allRows.sublist(i, endIndex);

          pdf.addPage(
            pw.Page(
              pageFormat: PdfPageFormat.a4.copyWith(
                marginLeft: 30,
                marginRight: 30,
                marginTop: 40,
                marginBottom: 40,
              ),
              build: (context) {
                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Sepet Ürünleri - Sayfa ${(i ~/ rowsPerPage) + 1}',
                      style: pw.TextStyle(
                        font: ttf,
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    pw.SizedBox(height: 10),
                    pw.Table(
                      border: pw.TableBorder.all(
                        color: PdfColors.grey400,
                        width: 0.5,
                      ),
                      columnWidths: {
                        0: const pw.FlexColumnWidth(4),
                        1: const pw.FlexColumnWidth(1.6),
                        2: const pw.FlexColumnWidth(1.2),
                        3: const pw.FlexColumnWidth(1.5),
                        4: const pw.FlexColumnWidth(1),
                        5: const pw.FlexColumnWidth(1.2),
                        6: const pw.FlexColumnWidth(1.5),
                      },
                      children: [
                        buildTableHeader(ttf),
                        ...pageRows,
                      ],
                    ),
                    buildFooter(products, ttf),
                  ],
                );
              },
            ),
          );
        }
        success = true;
      } catch (e) {
        rowsPerPage--;
      }
    }

    final output = await getTemporaryDirectory();
    final file = File('${output.path}/sepet_urunleri.pdf');
    await file.writeAsBytes(await pdf.save());
    await OpenFile.open(file.path);
  }
}
