import 'package:api/api.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:intl/intl.dart';
import 'package:kota_app/features/sub/active_orders_screen/active_orders_pdf_controller.dart';
import 'package:kota_app/features/sub/order_history_detail_screen/controller/order_history_detail_controller.dart';
import 'package:kota_app/product/navigation/modules/sub_route/sub_route_enums.dart';
import 'package:kota_app/product/utility/enums/module_padding_enums.dart';
import 'package:kota_app/product/widgets/other/empty_view.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:values/values.dart';

class ActiveOrdersDialog extends StatelessWidget {
  const ActiveOrdersDialog({
    required this.activeOrders,
    required this.isCurrencyTL,
    super.key,
  });

  final List<AlinanSiparisBilgileriL> activeOrders;
  final bool isCurrencyTL;

  @override
  Widget build(BuildContext context) {
    final labels = AppLocalization.getLabels(context);
    final pdfController = Get.put(ActiveOrdersPdfController());

    return Dialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
      ),
      child: Container(
        width: MediaQuery.of(context).size.width * 0.9,
        height: MediaQuery.of(context).size.height * 0.8,
        padding: EdgeInsets.all(ModulePadding.m.value),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  labels.activeOrders,
                  style: context.titleLarge.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Row(
                  children: [
                    IconButton(
                      icon: const Icon(Icons.picture_as_pdf),
                      onPressed: () async {
                        final pdf = await pdfController.generateActiveOrdersPdf(
                          activeOrders,
                          context,
                          isCurrencyTL,
                        );
                        await Printing.layoutPdf(
                          onLayout: (PdfPageFormat format) async => pdf.save(),
                        );
                      },
                      tooltip: labels.exportToPdf,
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Navigator.of(context).pop(),
                    ),
                  ],
                ),
              ],
            ),
            const Divider(),
            Expanded(
              child: activeOrders.isEmpty
                  ? EmptyView(message: labels.noActiveOrders)
                  : ListView.builder(
                      itemCount: activeOrders.length,
                      itemBuilder: (context, index) {
                        final order = activeOrders[index];
                        final price = isCurrencyTL
                            ? order.birimFiyat
                            : order.dovizliBirimFiyat;
                        final currencySymbol =
                            isCurrencyTL ? 'TL' : 'USD';

                        final isDarkMode = Theme.of(context).brightness == Brightness.dark;

                        return Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () {
                              // Sipariş detaylarını görmek için tıklandığında
                              final controller = Get.put(
                                OrderHistoryDetailController(
                                  id: order.alinanSiparisId!,
                                  isActiveOrder: true, // Aktif sipariş olduğunu belirt
                                ),
                              );

                              // Sipariş detay sayfasına yönlendir
                              context.pushNamed(
                                SubRouteEnums.orderHistoryDetail.name,
                                extra: controller,
                              );
                            },
                            borderRadius: BorderRadius.circular(12),
                            child: Container(
                              margin: EdgeInsets.symmetric(
                                horizontal: ModulePadding.xs.value,
                                vertical: ModulePadding.xxs.value,
                              ),
                              decoration: BoxDecoration(
                                color: isDarkMode ? Colors.grey[850] : Colors.white,
                                borderRadius: BorderRadius.circular(12),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withAlpha(13), // withOpacity(0.05) yerine
                                    blurRadius: 10,
                                    offset: const Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Sipariş başlık bilgileri
                                  Container(
                                    padding: EdgeInsets.all(ModulePadding.s.value),
                                    decoration: BoxDecoration(
                                      color: Theme.of(context).primaryColor.withAlpha(25), // withOpacity(0.1) yerine
                                      borderRadius: const BorderRadius.only(
                                        topLeft: Radius.circular(12),
                                        topRight: Radius.circular(12),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${labels.orderNumber}: ${order.alinanSiparisId}',
                                          style: context.titleSmall.copyWith(
                                            fontWeight: FontWeight.bold,
                                            color: Theme.of(context).primaryColor,
                                          ),
                                        ),
                                        if (order.tarih != null)
                                          Text(
                                            DateFormat('dd.MM.yyyy').format(order.tarih!),
                                            style: context.bodySmall.copyWith(
                                              color: isDarkMode ? Colors.white70 : Colors.black54,
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),

                                  // Ürün bilgileri
                                  Padding(
                                    padding: EdgeInsets.all(ModulePadding.s.value),
                                    child: Row(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        // Ürün kodu ve adı
                                        Expanded(
                                          flex: 3,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.start,
                                            children: [
                                              Text(
                                                order.urunKodu ?? '',
                                                style: context.labelMedium.copyWith(
                                                  color: Theme.of(context).primaryColor,
                                                  fontWeight: FontWeight.w500,
                                                ),
                                              ),
                                              const SizedBox(height: 4),
                                              Text(
                                                order.urunAdi ?? '',
                                                style: context.titleSmall.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                ),
                                                maxLines: 2,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ],
                                          ),
                                        ),

                                        // Miktar ve fiyat bilgileri
                                        Expanded(
                                          flex: 2,
                                          child: Column(
                                            crossAxisAlignment: CrossAxisAlignment.end,
                                            children: [
                                              // Miktar bilgisi
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                  horizontal: ModulePadding.xs.value,
                                                  vertical: 4,
                                                ),
                                                decoration: BoxDecoration(
                                                  color: Theme.of(context).primaryColor.withAlpha(25), // withOpacity(0.1) yerine
                                                  borderRadius: BorderRadius.circular(6),
                                                ),
                                                child: Text(
                                                  '${order.miktar}x',
                                                  style: context.labelMedium.copyWith(
                                                    color: Theme.of(context).primaryColor,
                                                    fontWeight: FontWeight.bold,
                                                  ),
                                                ),
                                              ),
                                              const SizedBox(height: 4),

                                              // Birim fiyat
                                              Text(
                                                '${price?.toStringAsFixed(2)} $currencySymbol',
                                                style: context.bodyMedium.copyWith(
                                                  color: isDarkMode ? Colors.grey[300] : Colors.grey[600],
                                                ),
                                              ),

                                              // Toplam tutar
                                              Text(
                                                '${order.tutar?.toStringAsFixed(2)} $currencySymbol',
                                                style: context.titleSmall.copyWith(
                                                  fontWeight: FontWeight.bold,
                                                  color: Theme.of(context).primaryColor,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),

                                  // Kalan miktar bilgisi
                                  Container(
                                    padding: EdgeInsets.symmetric(
                                      horizontal: ModulePadding.s.value,
                                      vertical: ModulePadding.xs.value,
                                    ),
                                    decoration: BoxDecoration(
                                      color: isDarkMode ? Colors.grey[800] : Colors.grey[100],
                                      borderRadius: const BorderRadius.only(
                                        bottomLeft: Radius.circular(12),
                                        bottomRight: Radius.circular(12),
                                      ),
                                    ),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Text(
                                          '${labels.remainingQuantity}:',
                                          style: context.bodyMedium,
                                        ),
                                        Container(
                                          padding: EdgeInsets.symmetric(
                                            horizontal: ModulePadding.xs.value,
                                            vertical: 2,
                                          ),
                                          decoration: BoxDecoration(
                                            color: Theme.of(context).colorScheme.secondary.withAlpha(50), // withOpacity(0.2) yerine
                                            borderRadius: BorderRadius.circular(4),
                                          ),
                                          child: Text(
                                            '${order.kalanAdet}',
                                            style: context.bodyMedium.copyWith(
                                              fontWeight: FontWeight.bold,
                                              color: Theme.of(context).colorScheme.secondary,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
