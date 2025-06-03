import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:kota_app/features/sub/order_history_detail_screen/view/components/product_card.dart';
import 'package:kota_app/product/base/base_view.dart';
import 'package:kota_app/product/utility/enums/module_padding_enums.dart';
import 'package:kota_app/product/utility/extentions/num_extension.dart';
import 'package:kota_app/product/widgets/app_bar/general_app_bar.dart';
import 'package:kota_app/product/widgets/other/empty_view.dart';
import 'package:printing/printing.dart';

// ignore: always_use_package_imports
import '../controller/order_history_detail_controller.dart';

class OrderHistoryDetail extends StatelessWidget {
  const OrderHistoryDetail({required this.controller, super.key});

  final OrderHistoryDetailController controller;

  @override
  Widget build(BuildContext context) {
    final labels = AppLocalization.getLabels(context);

    return Scaffold(
      key: controller.scaffoldKey,
      appBar: GeneralAppBar(
        title: labels.orderDetail,
        additionalIcon: IconButton(
          icon: const Icon(Icons.picture_as_pdf),
          onPressed: () => _generatePdf(context),
          tooltip: labels.exportToPdf,
        ),
      ),
      body: BaseView<OrderHistoryDetailController>(
        controller: controller,
        child: SingleChildScrollView(
          padding: EdgeInsets.all(ModulePadding.xs.value), // Reduced padding to give more space
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Order Summary Section
              Obx(() => controller.responseModel.id != null
                ? _buildOrderSummary(context)
                : const SizedBox.shrink(),
              ),

              SizedBox(height: ModulePadding.m.value),

              // Order Items Section
              Text(
                'Sipariş Ürünleri', // Order Items
                style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: ModulePadding.s.value),

              Obx(
                () => controller.cartProductItems.isNotEmpty
                  ? ListView.separated(
                      itemCount: controller.cartProductItems.length,
                      physics: const NeverScrollableScrollPhysics(),
                      shrinkWrap: true,
                      itemBuilder: (context, index) {
                        return ProductCard(
                          item: controller.cartProductItems[index],
                          isCurrencyTL: controller.isCurrencyTL,
                          onTap: () {
                            // Handle onTap action here
                          },
                          onTapRemove: () {
                            // Handle onTapRemove action here
                          },
                        );
                      },
                      separatorBuilder: (content, index) =>
                          SizedBox(height: ModulePadding.xxs.value),
                    )
                  : EmptyView(
                      message: labels.noOrderDetail,
                    ),
              ),

              // Active Orders Section (only show orders that are not part of main order)
              Obx(() => _hasUnrelatedActiveOrders()
                ? _buildActiveOrdersSection(context)
                : const SizedBox.shrink(),
              ),

              // Add bottom padding for better scrolling experience
              SizedBox(height: ModulePadding.l.value),
            ],
          ),
        ),
      ),
    );
  }

  /// Checks if there are active orders that are not related to the main order items
  bool _hasUnrelatedActiveOrders() {
    if (controller.activeOrders.isEmpty) return false;

    // Check if any active order has a product that's not in the main cart items
    for (final activeOrder in controller.activeOrders) {
      final isRelated = controller.cartProductItems.any(
        (cartItem) => cartItem.id == activeOrder.urunId,
      );
      if (!isRelated) {
        return true; // Found an unrelated active order
      }
    }
    return false; // All active orders are related to main order items
  }

  Widget _buildOrderSummary(BuildContext context) {
    final model = controller.responseModel;

    return Card(
      elevation: 2,
      margin: EdgeInsets.only(bottom: ModulePadding.s.value),
      child: Padding(
        padding: EdgeInsets.all(ModulePadding.m.value),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Sipariş Kodu: ${model.kod ?? ''}', // Order Code
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                Text(
                  model.tarih != null
                    ? DateFormat('dd.MM.yyyy').format(model.tarih!)
                    : '',
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ],
            ),
            SizedBox(height: ModulePadding.s.value),
            if (model.aciklama != null && model.aciklama!.isNotEmpty)
              Padding(
                padding: EdgeInsets.only(bottom: ModulePadding.s.value),
                child: Text(
                  'Açıklama: ${model.aciklama}', // Description
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
              ),

            // Discount Information - Compact Layout
            if (model.iskontoOrani != null && model.iskontoOrani! > 0) ...[
              Container(
                margin: EdgeInsets.only(bottom: ModulePadding.s.value),
                padding: EdgeInsets.all(ModulePadding.xs.value),
                decoration: BoxDecoration(
                  color: Colors.green.withAlpha(25),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: Colors.green.withAlpha(50)),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Expanded(
                      child: Text(
                        'İskonto: %${model.iskontoOrani!.toStringAsFixed(1)}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    if (model.iskontoTutari != null && model.iskontoTutari! > 0)
                      Text(
                        '- ${(controller.isCurrencyTL
                          ? model.iskontoTutari!
                          : (model.iskontoTutari! / (model.dovizKuru ?? 1))).formatPrice()}',
                        style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          color: Colors.green.shade700,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                  ],
                ),
              ),
            ],

            // Order Totals Section - Compact
            Container(
              padding: EdgeInsets.all(ModulePadding.xs.value),
              decoration: BoxDecoration(
                color: Theme.of(context).primaryColor.withAlpha(25),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: Theme.of(context).primaryColor.withAlpha(50),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Toplam Tutar:', // Total Amount
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    (controller.isCurrencyTL
                      ? model.toplamTutar!
                      : (model.dovizTutar ?? 0)).formatPrice(),
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ],
              ),
            ),

            SizedBox(height: ModulePadding.s.value),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  'Durum:', // Status
                  style: Theme.of(context).textTheme.bodyMedium,
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    horizontal: ModulePadding.s.value,
                    vertical: ModulePadding.xxs.value,
                  ),
                  decoration: BoxDecoration(
                    color: model.durum ?? false
                      ? Colors.green.withAlpha(50)
                      : Colors.red.withAlpha(50),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Text(
                    model.durum ?? false ? 'Aktif' : 'Pasif', // Active or Passive
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                      color: model.durum ?? false ? Colors.green : Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildActiveOrdersSection(BuildContext context) {
    final labels = AppLocalization.getLabels(context);

    // Filter to show only unrelated active orders
    final unrelatedOrders = controller.activeOrders.where((activeOrder) {
      return !controller.cartProductItems.any(
        (cartItem) => cartItem.id == activeOrder.urunId,
      );
    }).toList();

    if (unrelatedOrders.isEmpty) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: ModulePadding.m.value),
        Text(
          'Diğer Aktif Siparişler', // Other Active Orders
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ModulePadding.s.value),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: unrelatedOrders.length,
          itemBuilder: (context, index) {
            final order = unrelatedOrders[index];
            return Card(
              margin: EdgeInsets.only(bottom: ModulePadding.s.value),
              child: ListTile(
                title: Text(
                  order.urunAdi ?? labels.notAvailable,
                  style: Theme.of(context).textTheme.titleMedium,
                ),
                subtitle: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text('${labels.code}: ${order.urunKodu ?? ''}'),
                    Text('${labels.quantity}: ${order.miktar ?? 0}'),
                    if (order.kalanAdet != null)
                      Text('Kalan: ${order.kalanAdet}'), // Remaining
                  ],
                ),
                trailing: Text(
                  controller.isCurrencyTL
                    ? (order.birimFiyat ?? 0).formatPrice()
                    : (order.dovizliBirimFiyat ?? 0).formatPrice(),
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                  ),
                ),
              ),
            );
          },
        ),
      ],
    );
  }

  Future<void> _generatePdf(BuildContext context) async {
    if (controller.cartProductItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(AppLocalization.getLabels(context).noDataToReport)),
      );
      return;
    }

    // Use the existing PDF generation functionality
    // This would typically be implemented in a separate controller
    // For now, we'll just show a message
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('PDF export functionality will be implemented')),
    );
  }
}
