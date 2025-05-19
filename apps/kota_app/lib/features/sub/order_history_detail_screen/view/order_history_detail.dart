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
import 'package:values/values.dart';

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
        child: Padding(
          padding: EdgeInsets.all(ModulePadding.s.value),
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
                () => Flexible(
                  child: ListView.separated(
                    itemCount: controller.cartProductItems.length,
                    physics: const AlwaysScrollableScrollPhysics(),
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
                  ),
                ).isVisible(
                  value: controller.cartProductItems.isNotEmpty,
                  child: EmptyView(
                    message: labels.noOrderDetail,
                  ),
                ),
              ),

              // Active Orders Section (if any)
              Obx(() => controller.activeOrders.isNotEmpty
                ? _buildActiveOrdersSection(context)
                : const SizedBox.shrink(),
              ),
            ],
          ),
        ),
      ),
    );
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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(height: ModulePadding.m.value),
        Text(
          'Aktif Siparişler', // Active Orders
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
            fontWeight: FontWeight.bold,
          ),
        ),
        SizedBox(height: ModulePadding.s.value),
        ListView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: controller.activeOrders.length,
          itemBuilder: (context, index) {
            final order = controller.activeOrders[index];
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
