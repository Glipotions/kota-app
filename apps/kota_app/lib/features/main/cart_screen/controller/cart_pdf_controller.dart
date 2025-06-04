import 'dart:io';

import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kota_app/product/managers/cart_controller.dart';
import 'package:kota_app/product/models/cart_product_model.dart';
import 'package:kota_app/product/utility/extentions/num_extension.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class CartPdfController {
  static const int _maxItemsPerChunk = 50; // Reduced from 100 for better performance
  static const int _maxPagesLimit = 200; // Reasonable limit for cart PDFs

  Future<void> generateAndOpenCartPdf(
    BuildContext context,
    List<CartProductModel> products,
    CartController controller,
  ) async {
    final labels = AppLocalization.getLabels(context);
    
    if (products.isEmpty) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(labels.noDataToReport)),
        );
      }
      return;
    }

    try {
      final pdf = pw.Document();
      const baseAssetPath = 'assets/fonts/work_sans/';
      
      final ttfRegular = await rootBundle.load('${baseAssetPath}WorkSans-Regular.ttf');
      final ttf = pw.Font.ttf(ttfRegular);

      // Check if we need to chunk the products
      if (products.length > _maxItemsPerChunk) {
        await _generateChunkedPdf(pdf, products, controller, labels, ttf);
      } else {
        await _generateSinglePdf(pdf, products, controller, labels, ttf);
      }

      final output = await getTemporaryDirectory();
      final file = File('${output.path}/sepet_urunleri.pdf');
      await file.writeAsBytes(await pdf.save());
      await OpenFile.open(file.path);
      
    } catch (e) {
      if (context.mounted) {
        var errorMessage = 'PDF oluşturulurken bir hata oluştu: $e';
        
        // Provide specific error messages for common issues
        if (e.toString().contains('TooManyPages') || e.toString().contains('too many pages')) {
          errorMessage = 'Sepetinizde çok fazla ürün var. Lütfen bazı ürünleri kaldırarak tekrar deneyin.';
        } else if (e.toString().contains('OutOfMemory') || e.toString().contains('memory')) {
          errorMessage = 'Bellek yetersizliği nedeniyle PDF oluşturulamadı. Sepetinizdeki ürün sayısını azaltın.';
        }
        
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            duration: const Duration(seconds: 5),
          ),
        );
      }
    }
  }

  Future<void> _generateChunkedPdf(
    pw.Document pdf,
    List<CartProductModel> products,
    CartController controller,
    AppLocalizationLabel labels,
    pw.Font ttf,
  ) async {
    // Split products into chunks
    final chunks = <List<CartProductModel>>[];
    for (var i = 0; i < products.length; i += _maxItemsPerChunk) {
      final end = (i + _maxItemsPerChunk < products.length) ? i + _maxItemsPerChunk : products.length;
      chunks.add(products.sublist(i, end));
    }

    // Process each chunk separately
    for (var i = 0; i < chunks.length; i++) {
      final chunk = chunks[i];
      final isLastChunk = i == chunks.length - 1;
      
      await _addProductsPage(
        pdf: pdf,
        products: chunk,
        allProducts: products, // Pass all products for total calculations
        controller: controller,
        labels: labels,
        ttf: ttf,
        pageInfo: 'Sayfa ${i + 1} / ${chunks.length}',
        showTotals: isLastChunk, // Only show totals on the last page
      );
    }
  }

  Future<void> _generateSinglePdf(
    pw.Document pdf,
    List<CartProductModel> products,
    CartController controller,
    AppLocalizationLabel labels,
    pw.Font ttf,
  ) async {
    await _addProductsPage(
      pdf: pdf,
      products: products,
      allProducts: products,
      controller: controller,
      labels: labels,
      ttf: ttf,
      showTotals: true,
    );
  }

  Future<void> _addProductsPage({
    required pw.Document pdf,
    required List<CartProductModel> products,
    required List<CartProductModel> allProducts,
    required CartController controller,
    required AppLocalizationLabel labels,
    required pw.Font ttf,
    String? pageInfo,
    bool showTotals = false,
  }) async {
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

    // Create header row
    final headerRow = pw.TableRow(
      decoration: const pw.BoxDecoration(color: PdfColors.grey200),
      children: [
        _buildTableCell(labels.productName, ttf, isHeader: true),
        _buildTableCell(labels.productCode, ttf, isHeader: true),
        _buildTableCell(labels.size, ttf, isHeader: true),
        _buildTableCell(labels.color, ttf, isHeader: true),
        _buildTableCell(labels.quantity, ttf, isHeader: true),
        _buildTableCell(labels.price, ttf, isHeader: true),
        _buildTableCell(labels.total, ttf, isHeader: true),
      ],
    );

    // Create data rows
    final allRows = <pw.TableRow>[];
    for (final entry in groupedProducts.entries) {
      final groupProducts = entry.value;
      
      for (var i = 0; i < groupProducts.length; i++) {
        final product = groupProducts[i];
        final isOdd = allRows.length.isOdd;
        
        allRows.add(_buildProductRow(product, controller, ttf, isOdd));
      }
    }

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4.copyWith(
          marginLeft: 30,
          marginRight: 30,
          marginTop: 40,
          marginBottom: 40,
        ),
        maxPages: _maxPagesLimit,
        header: (context) => _buildHeader(labels, ttf, pageInfo),
        footer: showTotals
            ? (context) {
                final footerWidget = _buildFooter(allProducts, controller, labels, ttf, context);
                return footerWidget ?? pw.Container();
              }
            : null,
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
  }

  pw.Widget _buildHeader(AppLocalizationLabel labels, pw.Font ttf, String? pageInfo) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(
          '${labels.cartProducts}${pageInfo != null ? ' - $pageInfo' : ''}',
          style: pw.TextStyle(
            font: ttf,
            fontSize: 20,
            fontWeight: pw.FontWeight.bold,
          ),
        ),
        if (pageInfo != null)
          pw.Text(
            pageInfo,
            style: pw.TextStyle(
              font: ttf,
              fontSize: 12,
              color: PdfColors.grey600,
            ),
          ),
      ],
    );
  }

  pw.Widget _buildTableCell(String text, pw.Font ttf, {bool isHeader = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(8),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          font: ttf,
          fontSize: isHeader ? 12 : 10,
          fontWeight: isHeader ? pw.FontWeight.bold : pw.FontWeight.normal,
        ),
        textAlign: pw.TextAlign.center,
      ),
    );
  }

  pw.TableRow _buildProductRow(
    CartProductModel product,
    CartController controller,
    pw.Font ttf,
    bool isOdd,
  ) {
    final price = controller.isCurrencyTL ? product.price : product.currencyUnitPrice ?? 0;
    final total = price * product.quantity;

    return pw.TableRow(
      decoration: pw.BoxDecoration(
        color: isOdd ? PdfColors.grey50 : PdfColors.white,
      ),
      children: [
        _buildTableCell(product.name ?? '', ttf),
        _buildTableCell(product.code, ttf),
        _buildTableCell(product.sizeName ?? '', ttf),
        _buildTableCell(product.colorName ?? '', ttf),
        _buildTableCell(product.quantity.toString(), ttf),
        _buildTableCell(price.formatPrice(), ttf),
        _buildTableCell(total.formatPrice(), ttf),
      ],
    );
  }

  pw.Widget? _buildFooter(
    List<CartProductModel> allProducts,
    CartController controller,
    AppLocalizationLabel labels,
    pw.Font ttf,
    pw.Context context,
  ) {
    if (context.pageNumber != context.pagesCount) {
      return null;
    }

    final totalQuantity = allProducts.fold<int>(0, (sum, product) => sum + product.quantity);
    final totalPriceWithoutDiscount = allProducts.fold<double>(
      0,
      (sum, product) => sum + (controller.isCurrencyTL
          ? product.price * product.quantity
          : product.currencyUnitPrice! * product.quantity),
    );

    final totalPrice = controller.cartDiscountRate.value > 0
        ? totalPriceWithoutDiscount * (1 - controller.cartDiscountRate.value / 100)
        : totalPriceWithoutDiscount;

    return pw.Container(
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
        border: pw.Border.all(color: PdfColors.grey400),
      ),
      padding: const pw.EdgeInsets.all(10),
      margin: const pw.EdgeInsets.only(top: 20),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Text(
                '${labels.totalQuantity}: ',
                style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                totalQuantity.toString(),
                style: pw.TextStyle(font: ttf, fontWeight: pw.FontWeight.bold),
              ),
            ],
          ),
          pw.SizedBox(height: 8),
          if (controller.cartDiscountRate.value > 0) ...[
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Text(
                  'Toplam Tutar: ',
                  style: pw.TextStyle(font: ttf, fontSize: 12, color: PdfColors.grey700),
                ),
                pw.Text(
                  totalPriceWithoutDiscount.formatPrice(),
                  style: pw.TextStyle(
                    font: ttf,
                    fontSize: 12,
                    color: PdfColors.grey700,
                    decoration: pw.TextDecoration.lineThrough,
                  ),
                ),
              ],
            ),
            pw.SizedBox(height: 4),
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.end,
              children: [
                pw.Text(
                  'İskonto (%${controller.cartDiscountRate.value.toStringAsFixed(2)}): ',
                  style: pw.TextStyle(font: ttf, fontSize: 12, color: PdfColors.red),
                ),
                pw.Text(
                  '- ${(totalPriceWithoutDiscount - totalPrice).formatPrice()}',
                  style: pw.TextStyle(font: ttf, fontSize: 12, color: PdfColors.red),
                ),
              ],
            ),
            pw.SizedBox(height: 4),
          ],
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.end,
            children: [
              pw.Text(
                '${labels.totalAmount}: ',
                style: pw.TextStyle(font: ttf, fontSize: 14, fontWeight: pw.FontWeight.bold),
              ),
              pw.Text(
                totalPrice.formatPrice(),
                style: pw.TextStyle(font: ttf, fontSize: 14, fontWeight: pw.FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
