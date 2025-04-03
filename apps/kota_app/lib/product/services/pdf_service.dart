import 'package:api/api.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:kota_app/product/utility/extentions/index.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

/// Service responsible for generating PDF documents
class PDFService {
  /// Generates a PDF invoice from the given sales invoice data
  static Future<Uint8List> generateInvoicePDF(
    SalesInvoiceDetailResponseModel invoice,
    BuildContext context,
  ) async {
    final pdf = pw.Document();

    // Get localization
    final localization = AppLocalization.getLabels(context);

    // Load custom fonts from assets for Turkish character support
    final regularFont =
        await _loadFont('assets/fonts/work_sans/WorkSans-Regular.ttf');
    final boldFont =
        await _loadFont('assets/fonts/work_sans/WorkSans-Bold.ttf');

    final dateFormatter = DateFormat('dd/MM/yyyy');
    final currentDate = dateFormatter.format(DateTime.now());

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        build: (pw.Context context) {
          return [
            _buildHeader(boldFont, currentDate, localization),
            pw.SizedBox(height: 20),
            _buildTitle(boldFont, localization),
            pw.SizedBox(height: 20),
            _buildInvoiceItems(invoice.faturaBilgileri ?? [], regularFont,
                boldFont, localization, invoice.dovizTuru),
            pw.SizedBox(height: 20),
            _buildTotal(invoice, boldFont, regularFont, localization),
            pw.SizedBox(height: 40),
            _buildFooter(regularFont, localization),
          ];
        },
      ),
    );

    return pdf.save();
  }

  /// Loads a custom font from assets
  static Future<pw.Font> _loadFont(String assetPath) async {
    final fontData = await rootBundle.load(assetPath);
    return pw.Font.ttf(fontData);
  }

  /// Shows a PDF document in a preview dialog
  static Future<void> showPDF(
    BuildContext context,
    Uint8List pdfBytes,
    String title,
  ) async {
    await Printing.layoutPdf(
      onLayout: (PdfPageFormat format) async => pdfBytes,
      name: title,
      format: PdfPageFormat.a4,
    );
  }

  static pw.Widget _buildHeader(
      pw.Font fontBold, String date, AppLocalizationLabel localization) {
    return pw.Row(
      mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
      children: [
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Text(
              'KOTA TEKSTİL',
              style: pw.TextStyle(
                font: fontBold,
                fontSize: 24,
                color: PdfColors.blue900,
              ),
            ),
            pw.Text(
              localization.salesInvoice,
              style: pw.TextStyle(
                font: fontBold,
                fontSize: 16,
                color: PdfColors.grey700,
              ),
            ),
          ],
        ),
        pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.end,
          children: [
            pw.Text(
              '${localization.invoiceDate}:',
              style: pw.TextStyle(
                font: fontBold,
                color: PdfColors.grey700,
              ),
            ),
            pw.Text(
              date,
              style: const pw.TextStyle(
                color: PdfColors.grey700,
              ),
            ),
          ],
        ),
      ],
    );
  }

  static pw.Widget _buildTitle(
      pw.Font fontBold, AppLocalizationLabel localization) {
    return pw.Container(
      width: double.infinity,
      padding: const pw.EdgeInsets.all(10),
      decoration: pw.BoxDecoration(
        color: PdfColors.blue100,
        borderRadius: pw.BorderRadius.circular(8),
      ),
      child: pw.Text(
        localization.invoiceDetails,
        textAlign: pw.TextAlign.center,
        style: pw.TextStyle(
          font: fontBold,
          fontSize: 16,
          color: PdfColors.blue900,
        ),
      ),
    );
  }

  static pw.Widget _buildInvoiceItems(
    List<SalesInvoiceDetailItemModel> items,
    pw.Font font,
    pw.Font fontBold,
    AppLocalizationLabel localization,
    int? currencyType,
  ) {
    final headers = [
      localization.invoiceProductCode,
      localization.invoiceProductName,
      localization.invoiceQuantity,
      localization.unitPriceInvoice,
      localization.totalInvoice,
    ];

    return pw.Table(
      border: pw.TableBorder.all(color: PdfColors.grey400),
      columnWidths: {
        0: const pw.FlexColumnWidth(2), // Kod
        1: const pw.FlexColumnWidth(5), // Ürün Adı
        2: const pw.FlexColumnWidth(1.5), // Miktar
        3: const pw.FlexColumnWidth(1.5), // Birim Fiyat
        4: const pw.FlexColumnWidth(2), // Toplam
      },
      children: [
        // Header row
        pw.TableRow(
          decoration: const pw.BoxDecoration(color: PdfColors.grey200),
          children: headers
              .map(
                (header) => pw.Padding(
                  padding: const pw.EdgeInsets.all(8),
                  child: pw.Text(
                    header,
                    style: pw.TextStyle(font: fontBold),
                    textAlign: pw.TextAlign.center,
                  ),
                ),
              )
              .toList(),
        ),
        // Data rows
        ...items.map(
          (item) => pw.TableRow(
            children: [
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text(
                  item.code ?? '',
                  style: pw.TextStyle(font: font),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text(
                  item.productName ?? '',
                  style: pw.TextStyle(font: font),
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text(
                  item.miktar.toString(),
                  style: pw.TextStyle(font: font),
                  textAlign: pw.TextAlign.center,
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text(
                  item.dovizliBirimFiyat == 0 || item.dovizliBirimFiyat == null
                      ? item.birimFiyat!.formatPrice()
                      : item.dovizliBirimFiyat!.formatPrice(),
                  style: pw.TextStyle(font: font),
                  textAlign: pw.TextAlign.right,
                ),
              ),
              pw.Padding(
                padding: const pw.EdgeInsets.all(8),
                child: pw.Text(
                  item.tutar!.formatPrice(),
                  style: pw.TextStyle(font: fontBold),
                  textAlign: pw.TextAlign.right,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  static pw.Widget _buildTotal(
    SalesInvoiceDetailResponseModel invoice,
    pw.Font fontBold,
    pw.Font font,
    AppLocalizationLabel localization,
  ) {
    final totalAmount = invoice.isDovizFatura == true
        ? invoice.dovizTutar ?? 0
        : invoice.toplamTutar ?? 0;
    final totalKDV = invoice.kdvTutari ?? 0;
    final totalBeforeKDV = totalAmount - totalKDV;
    final discountTotal = invoice.iskontoTutari ?? 0;

    return pw.Container(
      alignment: pw.Alignment.centerRight,
      child: pw.Column(
        crossAxisAlignment: pw.CrossAxisAlignment.end,
        children: [
          pw.Row(
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              pw.Text(
                '${localization.subtotal}: ',
                style: pw.TextStyle(font: fontBold),
              ),
              pw.Text(
                totalBeforeKDV.formatPrice(),
                style: pw.TextStyle(font: font),
              ),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              pw.Text(
                '${localization.discount} (%${invoice.iskontoOrani}): ',
                style: pw.TextStyle(font: fontBold),
              ),
              pw.Text(
                discountTotal.formatPrice(),
                style: pw.TextStyle(font: font),
              ),
            ],
          ),
          pw.SizedBox(height: 5),
          pw.Row(
            mainAxisSize: pw.MainAxisSize.min,
            children: [
              pw.Text(
                '${localization.vatTotal} (%${invoice.kdvSekli != 1 ? 0 : invoice.faturaKdvOrani}): ',
                style: pw.TextStyle(font: fontBold),
              ),
              pw.Text(
                totalKDV.formatPrice(),
                style: pw.TextStyle(font: font),
              ),
            ],
          ),
          pw.SizedBox(height: 10),
          pw.Container(
            padding: const pw.EdgeInsets.all(8),
            decoration: pw.BoxDecoration(
              color: PdfColors.blue100,
              borderRadius: pw.BorderRadius.circular(4),
            ),
            child: pw.Row(
              mainAxisSize: pw.MainAxisSize.min,
              children: [
                pw.Text(
                  '${localization.grandTotal}: ',
                  style: pw.TextStyle(
                    font: fontBold,
                    fontSize: 14,
                    color: PdfColors.blue900,
                  ),
                ),
                pw.Text(
                  totalAmount.formatPrice(),
                  style: pw.TextStyle(
                    font: fontBold,
                    fontSize: 14,
                    color: PdfColors.blue900,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  static pw.Widget _buildFooter(
      pw.Font font, AppLocalizationLabel localization) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.center,
      children: [
        pw.Divider(),
        pw.SizedBox(height: 10),
        pw.Text(
          localization.electronicInvoiceNote,
          style: pw.TextStyle(
            font: font,
            color: PdfColors.grey700,
            fontSize: 10,
          ),
          textAlign: pw.TextAlign.center,
        ),
        pw.SizedBox(height: 5),
        pw.Text(
          'KOTA TEKSTİL  ${DateTime.now().year}',
          style: pw.TextStyle(
            font: font,
            color: PdfColors.grey700,
            fontSize: 10,
          ),
          textAlign: pw.TextAlign.center,
        ),
      ],
    );
  }
}
