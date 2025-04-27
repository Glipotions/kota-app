import 'package:api/api.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class ActiveOrdersPdfController extends GetxController {
  String formatDate(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }

  bool _isCurrencyTL = true;

  Future<pw.ThemeData> pdfThemeData() async {
    const baseAssetPath = 'assets/fonts/work_sans/';

    final ttfRegular =
        await rootBundle.load('${baseAssetPath}WorkSans-Regular.ttf');
    final ttfBold = await rootBundle.load('${baseAssetPath}WorkSans-Bold.ttf');

    return pw.ThemeData.withFont(
      base: pw.Font.ttf(ttfRegular.buffer.asByteData()),
      bold: pw.Font.ttf(ttfBold.buffer.asByteData()),
    );
  }

  Future<pw.Document> generateActiveOrdersPdf(
    List<AlinanSiparisBilgileriL> orders,
    BuildContext context,
    bool isCurrencyTL,
  ) async {
    _isCurrencyTL = isCurrencyTL;
    final pdf = pw.Document();
    final labels = AppLocalization.getLabels(context);
    const margin = 20.0;

    // Check if the order list is too large (more than 100 items)
    if (orders.length > 100) {
      // Split orders into chunks of 100 items to avoid TooManyPagesException
      final chunks = <List<AlinanSiparisBilgileriL>>[];
      for (var i = 0; i < orders.length; i += 100) {
        final end = (i + 100 < orders.length) ? i + 100 : orders.length;
        chunks.add(orders.sublist(i, end));
      }

      // Process each chunk separately
      for (var i = 0; i < chunks.length; i++) {
        final chunk = chunks[i];
        await _addOrdersPage(
          pdf: pdf,
          orders: chunk,
          labels: labels,
          isCurrencyTL: isCurrencyTL,
          margin: margin,
          pageInfo: 'Batch ${i + 1} of ${chunks.length}',
        );
      }
    } else {
      // For smaller datasets, process all at once
      await _addOrdersPage(
        pdf: pdf,
        orders: orders,
        labels: labels,
        isCurrencyTL: isCurrencyTL,
        margin: margin,
      );
    }

    return pdf;
  }

  // Helper method to add a page with orders
  Future<void> _addOrdersPage({
    required pw.Document pdf,
    required List<AlinanSiparisBilgileriL> orders,
    required AppLocalizationLabel labels,
    required bool isCurrencyTL,
    required double margin,
    String? pageInfo,
  }) async {
    pdf.addPage(
      pw.MultiPage(
        theme: await pdfThemeData(),
        pageFormat: PdfPageFormat.a4,
        margin: pw.EdgeInsets.all(margin),
        maxPages: 500, // Increased maxPages limit
        footer: (pw.Context context) {
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 1.0 * PdfPageFormat.cm),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.end,
              children: [
                if (pageInfo != null)
                  pw.Text(
                    pageInfo,
                    style: pw.Theme.of(context)
                        .defaultTextStyle
                        .copyWith(color: PdfColors.grey),
                  ),
                pw.SizedBox(height: 5),
                pw.Text(
                  'Page ${context.pageNumber} of ${context.pagesCount}',
                  style: pw.Theme.of(context)
                      .defaultTextStyle
                      .copyWith(color: PdfColors.grey),
                ),
              ],
            ),
          );
        },
        build: (pw.Context context) {
          // List of widgets for the page content
          List<pw.Widget> content = [];

          // Add custom header content
          content.add(header());
          content.add(pw.SizedBox(height: 10));

          // Add the Table with optimized column widths
          content.add(
            pw.Table(
              border: pw.TableBorder.all(color: PdfColors.grey600),
              columnWidths: {
                0: const pw.FlexColumnWidth(1.2), // Order ID
                1: const pw.FlexColumnWidth(1.2), // Product Code
                2: const pw.FlexColumnWidth(2.5), // Product Name
                3: const pw.FlexColumnWidth(0.8), // Quantity
                4: const pw.FlexColumnWidth(1.2), // Unit Price
                5: const pw.FlexColumnWidth(1.2), // Total
                6: const pw.FlexColumnWidth(1.2), // Remaining
              },
              children: [
                // Table header row
                buildTableHeader(),
                // Table data rows
                for (int i = 0; i < orders.length; i++)
                  buildTableRow(orders[i], i.isOdd),
              ],
            ),
          );

          // Add custom footer content (summary)
          content.add(pw.SizedBox(height: 20));
          content.add(footer(orders, isCurrencyTL, labels));

          // Return the list of widgets for MultiPage to handle
          return content;
        },
      ),
    );
  }

  pw.Widget footer(List<AlinanSiparisBilgileriL> orders, bool isCurrencyTL, AppLocalizationLabel labels) {
    double totalAmount = 0;
    for (final order in orders) {
      final price = isCurrencyTL
          ? order.tutar
          : ((order.dovizliBirimFiyat ?? 0) * (order.miktar ?? 0));
      totalAmount += price ?? 0;
    }

    return pw.Container(
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
        border: pw.Border.all(color: PdfColors.grey400),
      ),
      margin: const pw.EdgeInsets.only(top: 10),
      padding: const pw.EdgeInsets.all(10),
      child: pw.Row(
        mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
        children: [
          pw.Text(
            labels.totalAmount,
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 14,
            ),
          ),
          pw.Text(
            '${totalAmount.toStringAsFixed(2)} ${isCurrencyTL ? 'TL' : 'USD'}',
            style: pw.TextStyle(
              fontWeight: pw.FontWeight.bold,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  pw.Widget header() {
    return pw.Container(
      decoration: pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
        border: pw.Border.all(color: PdfColors.grey400),
      ),
      margin: const pw.EdgeInsets.only(bottom: 10),
      padding: const pw.EdgeInsets.all(10),
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Row(
            mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
            children: [
              pw.Text(
                'KOTA TEKSTİL',
                style: pw.TextStyle(
                  fontSize: 20,
                  fontWeight: pw.FontWeight.bold,
                ),
              ),
              pw.Text(
                formatDate(DateTime.now()),
                style: const pw.TextStyle(
                  fontSize: 14,
                ),
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Text(
            'Active Orders',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  pw.TableRow buildTableHeader() {
    return pw.TableRow(
      decoration: const pw.BoxDecoration(color: PdfColors.grey200),
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(5),
          child: pw.Text(
            'Order Number',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            textAlign: pw.TextAlign.center,
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(5),
          child: pw.Text(
            'Product Code',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            textAlign: pw.TextAlign.center,
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(5),
          child: pw.Text(
            'Product Name',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            textAlign: pw.TextAlign.center,
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(5),
          child: pw.Text(
            'Quantity',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            textAlign: pw.TextAlign.center,
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(5),
          child: pw.Text(
            'Unit Price',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            textAlign: pw.TextAlign.center,
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(5),
          child: pw.Text(
            'Total',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            textAlign: pw.TextAlign.center,
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(5),
          child: pw.Text(
            'Remaining Quantity',
            style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
            textAlign: pw.TextAlign.center,
          ),
        ),
      ],
    );
  }

  pw.TableRow buildTableRow(AlinanSiparisBilgileriL order, bool isOdd) {
    final price = _isCurrencyTL ? order.birimFiyat : order.dovizliBirimFiyat;
    final total = _isCurrencyTL
        ? order.tutar
        : ((order.dovizliBirimFiyat ?? 0) * (order.miktar ?? 0));

    return pw.TableRow(
      decoration: pw.BoxDecoration(
        color: isOdd ? PdfColors.grey100 : PdfColors.white,
      ),
      children: [
        pw.Padding(
          padding: const pw.EdgeInsets.all(5),
          child: pw.Text(
            order.alinanSiparisId.toString(),
            textAlign: pw.TextAlign.center,
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(5),
          child: pw.Text(
            order.urunKodu ?? '',
            textAlign: pw.TextAlign.center,
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(5),
          child: pw.Text(
            order.urunAdi ?? '',
            textAlign: pw.TextAlign.left,
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(5),
          child: pw.Text(
            order.miktar.toString(),
            textAlign: pw.TextAlign.center,
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(5),
          child: pw.Text(
            price?.toStringAsFixed(2) ?? '0.00',
            textAlign: pw.TextAlign.right,
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(5),
          child: pw.Text(
            total?.toStringAsFixed(2) ?? '0.00',
            textAlign: pw.TextAlign.right,
          ),
        ),
        pw.Padding(
          padding: const pw.EdgeInsets.all(5),
          child: pw.Text(
            order.kalanAdet.toString(),
            textAlign: pw.TextAlign.center,
          ),
        ),
      ],
    );
  }
}
