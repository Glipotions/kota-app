import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kota_app/product/models/cart_product_model.dart';
import 'package:kota_app/product/utility/extentions/index.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

class OrderPdfController extends GetxController {
  String formatDate(DateTime date) {
    return DateFormat('dd.MM.yyyy').format(date);
  }

  Future<pw.ThemeData> pdfThemeData() async {
    const baseAssetPath = 'assets/fonts/work_sans/';

    final ttfRegular =
        await rootBundle.load('${baseAssetPath}WorkSans-Regular.ttf');
    final ttfBold = await rootBundle.load('${baseAssetPath}WorkSans-Bold.ttf');
    final ttfItalic =
        await rootBundle.load('${baseAssetPath}WorkSans-Italic.ttf');
    final ttfBoldItalic =
        await rootBundle.load('${baseAssetPath}WorkSans-BoldItalic.ttf');

    final fontRegular = pw.Font.ttf(ttfRegular);
    final fontBold = pw.Font.ttf(ttfBold);
    final fontItalic = pw.Font.ttf(ttfItalic);
    final fontBoldItalic = pw.Font.ttf(ttfBoldItalic);

    final theme = pw.ThemeData.withFont(
      base: fontRegular,
      bold: fontBold,
      italic: fontItalic,
      boldItalic: fontBoldItalic,
    );
    return theme;
  }

  Future<pw.Document> generateOrderHistoryDetailPdf(
    CartProductPdfModel invoice,
    BuildContext context,
  ) async {
    final pdf = pw.Document();
    final labels = AppLocalization.getLabels(context);

    const pageHeight = 841.89;
    const margin = 20.0;
    const headerHeight = 100.0;
    const footerHeight = 100.0;
    const usableHeight = pageHeight - headerHeight - footerHeight - 2 * margin;

    pw.Widget header(CartProductPdfModel invoice) {
      return pw.Container(
        decoration: pw.BoxDecoration(
          color: PdfColors.grey100,
          borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
          border: pw.Border.all(color: PdfColors.grey400),
        ),
        padding: const pw.EdgeInsets.all(10),
        margin: const pw.EdgeInsets.only(bottom: 20),
        child: pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              labels.orderSummary,
              style: pw.TextStyle(
                fontSize: 20,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.blue900,
              ),
            ),
            pw.SizedBox(height: 10),
            if (invoice.description != null && invoice.description!.isNotEmpty)
              pw.Container(
                padding:
                    const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                decoration: pw.BoxDecoration(
                  color: PdfColors.white,
                  borderRadius:
                      const pw.BorderRadius.all(pw.Radius.circular(4)),
                  border: pw.Border.all(color: PdfColors.grey300),
                ),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      '${labels.description}:',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                        color: PdfColors.blue900,
                      ),
                    ),
                    pw.SizedBox(height: 4),
                    pw.Text(
                      invoice.description ?? '',
                      style: const pw.TextStyle(
                        fontSize: 11,
                      ),
                    ),
                  ],
                ),
              ),
          ],
        ),
      );
    }

    pw.Widget footer(CartProductPdfModel invoice) {
      final summaryBoxDecoration = pw.BoxDecoration(
        color: PdfColors.grey100,
        borderRadius: const pw.BorderRadius.all(pw.Radius.circular(4)),
        border: pw.Border.all(color: PdfColors.grey400),
      );

      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.SizedBox(height: 20),
          pw.Container(
            decoration: summaryBoxDecoration,
            padding: const pw.EdgeInsets.all(10),
            child: pw.Table(
              columnWidths: {
                0: const pw.FlexColumnWidth(2),
                1: const pw.FlexColumnWidth(2),
                2: const pw.FlexColumnWidth(2),
                3: const pw.FlexColumnWidth(2),
              },
              children: [
                pw.TableRow(
                  decoration: const pw.BoxDecoration(
                    border: pw.Border(
                      bottom: pw.BorderSide(color: PdfColors.grey300),
                    ),
                  ),
                  children: [
                    pw.Container(),
                    pw.Container(),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      child: pw.Text(
                        '${labels.quantityTotal}:',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 12,
                          color: PdfColors.blue900,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.symmetric(vertical: 4),
                      child: pw.Text(
                        invoice.items!
                            .map((product) => product.quantity)
                            .fold<int>(
                              0,
                              (sum, product) => sum + product,
                            )
                            .toString(),
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 12,
                          color: PdfColors.blue900,
                        ),
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                  ],
                ),
                pw.TableRow(
                  children: [
                    pw.Container(),
                    pw.Container(),
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(top: 8),
                      child: pw.Text(
                        '${labels.orderTotalPrice}:',
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 14,
                          color: PdfColors.blue900,
                        ),
                      ),
                    ),
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(top: 8),
                      child: pw.Text(
                        invoice.totalPrice!.formatPrice(),
                        style: pw.TextStyle(
                          fontWeight: pw.FontWeight.bold,
                          fontSize: 14,
                          color: PdfColors.blue900,
                        ),
                        textAlign: pw.TextAlign.right,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      );
    }

    pw.TableRow buildTableHeader() {
      return pw.TableRow(
        decoration: const pw.BoxDecoration(
          color: PdfColors.blue900,
          borderRadius: pw.BorderRadius.vertical(top: pw.Radius.circular(4)),
        ),
        children: [
          labels.productCode,
          labels.productName,
          labels.quantity,
          labels.unitPrice,
          labels.amount,
        ]
            .map(
              (text) => pw.Container(
                padding:
                    const pw.EdgeInsets.symmetric(vertical: 8, horizontal: 4),
                child: pw.Text(
                  text,
                  style: pw.TextStyle(
                    color: PdfColors.white,
                    fontWeight: pw.FontWeight.bold,
                    fontSize: 12,
                  ),
                  textAlign: pw.TextAlign.center,
                ),
              ),
            )
            .toList(),
      );
    }

    pw.TableRow buildTableRow(CartProductModel item, bool oddRow) {
      return pw.TableRow(
        decoration: pw.BoxDecoration(
          color: oddRow ? PdfColors.grey100 : PdfColors.white,
        ),
        children: [
          item.code,
          item.name ?? '',
          item.quantity.toString(),
          item.price.formatPrice(),
          (item.price * item.quantity).formatPrice(),
        ]
            .map(
              (text) => pw.Container(
                padding:
                    const pw.EdgeInsets.symmetric(vertical: 4, horizontal: 4),
                child: pw.Text(
                  text,
                  style: const pw.TextStyle(fontSize: 10),
                  textAlign: text == item.name
                      ? pw.TextAlign.left
                      : pw.TextAlign.center,
                ),
              ),
            )
            .toList(),
      );
    }

    pdf.addPage(
      pw.MultiPage(
        theme: await pdfThemeData(),
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(margin),
        maxPages: 100, // Set a higher maximum page limit
        footer: (pw.Context context) {
          // Add page numbering in the footer
          return pw.Container(
            alignment: pw.Alignment.centerRight,
            margin: const pw.EdgeInsets.only(top: 10),
            child: pw.Text(
              '${context.pageNumber}/${context.pagesCount}',
              style: pw.TextStyle(
                fontSize: 10,
                fontWeight: pw.FontWeight.bold,
                color: PdfColors.grey700,
              ),
            ),
          );
        },
        build: (pw.Context context) {
          // If there are too many items, we might need to chunk them
          final items = invoice.items ?? [];
          
          final List<pw.Widget> content = [
            header(invoice),
            pw.SizedBox(height: 10),
            // Create a single table for all items
            pw.Table(
              border: pw.TableBorder.all(),
              columnWidths: {
                0: const pw.FlexColumnWidth(),
                1: const pw.FlexColumnWidth(3),
                2: const pw.FlexColumnWidth(),
                3: const pw.FlexColumnWidth(),
                4: const pw.FlexColumnWidth(),
              },
              children: [
                // Add the header row once
                buildTableHeader(),
                // Add all item rows
                for (int i = 0; i < items.length; i++)
                  buildTableRow(items[i], i % 2 == 1),
              ],
            ),
            pw.SizedBox(height: 20),
            footer(invoice),
          ];
          
          return content;
        },
      ),
    );

    return pdf;
  }
}
