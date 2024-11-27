import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kota_app/product/models/cart_product_model.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:values/values.dart';

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
  ) async {
    final pdf = pw.Document();

    const pageHeight = 841.89;
    const margin = 20.0;
    const headerHeight = 100.0;
    const footerHeight = 100.0;
    const usableHeight = pageHeight - headerHeight - footerHeight - 2 * margin;

    pw.Widget header(CartProductPdfModel invoice) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.Text(
            'Sipariş Özeti',
            style: pw.TextStyle(fontSize: 20, fontWeight: pw.FontWeight.bold),
          ),
          // pw.SizedBox(height: 10),
          // pw.Row(
          //   mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
          //   children: [
          //     pw.Text('Firma Unvanı: ${invoice.cariHesapAdi}'),
          //     pw.Text('Tarih: ${formatDate(invoice.tarih!)}'),
          //   ],
          // ),
          pw.SizedBox(height: 10),
        ],
      );
    }

    pw.Widget footer(CartProductPdfModel invoice) {
      return pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.SizedBox(height: 20),
          pw.Table(
            columnWidths: {
              0: const pw.FlexColumnWidth(2),
              1: const pw.FlexColumnWidth(2),
              2: const pw.FlexColumnWidth(2),
              3: const pw.FlexColumnWidth(2),
            },
            children: [
              pw.TableRow(
                children: [
                  pw.Container(),
                  pw.Container(),
                  pw.Text(
                    'Sipariş Toplami:',
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  pw.Text(
                    invoice.totalPrice!.toStringAsFixed(2),
                    style: pw.TextStyle(
                      fontWeight: pw.FontWeight.bold,
                      fontSize: 12,
                    ),
                    textAlign: pw.TextAlign.right,
                  ),
                ],
              ),
            ],
          ),
        ],
      );
    }

    pdf.addPage(
      pw.MultiPage(
        theme: await pdfThemeData(),
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(margin),
        build: (pw.Context context) {
          return [
            header(invoice),
            pw.SizedBox(height: 10),
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
                pw.TableRow(
                  children: [
                    pw.Text(
                      'Ürün Kodu',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                    ),
                    pw.Text(
                      'Ürün Adı',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.Text(
                      'Miktar',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      textAlign: pw.TextAlign.center,
                    ),
                    pw.Text(
                      'Birim Fiyat',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      textAlign: pw.TextAlign.right,
                    ),
                    pw.Text(
                      'Tutar',
                      style: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                      textAlign: pw.TextAlign.right,
                    ),
                  ],
                ),
                for (final product in invoice.items!)
                  pw.TableRow(
                    children: [
                      pw.Text(
                        product.code,
                        style: const pw.TextStyle(fontSize: 9),
                      ),
                      pw.Text(
                        '${product.name}',
                        style: const pw.TextStyle(fontSize: 9),
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.Text(
                        '${product.quantity}',
                        style: const pw.TextStyle(fontSize: 12),
                        textAlign: pw.TextAlign.center,
                      ),
                      pw.Text(
                        '${product.price}',
                        style: const pw.TextStyle(fontSize: 12),
                        textAlign: pw.TextAlign.right,
                      ),
                      pw.Text(
                        (product.price * product.quantity).formatPrice(),
                        style: const pw.TextStyle(fontSize: 12),
                        textAlign: pw.TextAlign.right,
                      ),
                    ],
                  ),
              ],
            ),
            footer(invoice),
          ];
        },
      ),
    );

    return pdf;
  }
}
