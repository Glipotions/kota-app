import 'package:api/src/repositories/character_module/models/response/active_orders_response_model.dart'; // Import the data model
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../controller/active_orders_controller.dart';

class ActiveOrders extends StatelessWidget {
  const ActiveOrders({super.key, required this.controller});
  final ActiveOrdersController controller;

  @override
  Widget build(BuildContext context) {
    final labels = AppLocalization.getLabels(context);

    return Scaffold(
      key: controller.scaffoldKey,
      appBar: AppBar(
        title: Text(labels.activeOrders),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: controller.fetchActiveOrders,
            tooltip: labels.refresh, // Refresh
          ),
          // Add PDF button
          IconButton(
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: controller.showActiveOrdersPdf, // TODO: Implement this method in ActiveOrdersController
            tooltip: labels.viewPdf, // View PDF
          ),
        ],
      ),
      body: Obx( // Use Obx to listen to controller changes
        () {
          if (controller.isLoading) {
            return const Center(child: CircularProgressIndicator.adaptive());
          }

          if (controller.hasError) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Icon(Icons.error_outline, color: Colors.red, size: 48),
                    const SizedBox(height: 16),
                    Text(
                      labels.errorLoadingOrders,
                      textAlign: TextAlign.center,
                      style: Get.textTheme.titleMedium,
                    ),
                    const SizedBox(height: 8),
                    Text(
                      controller.errorMessage!,
                      textAlign: TextAlign.center,
                      style: Get.textTheme.bodyMedium?.copyWith(color: Colors.red),
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton.icon(
                      icon: const Icon(Icons.refresh),
                      label: Text(labels.retry), // Retry
                      onPressed: controller.fetchActiveOrders,
                    )
                  ],
                ),
              ),
            );
          }

          if (controller.activeOrders.isEmpty) {
            return Center(
              child: Text(
                labels.noActiveOrdersFound,
                style: TextStyle(fontSize: 16, color: Colors.grey),
              ),
            );
          }

          // Display the list of active orders
          return ListView.builder(
            padding: const EdgeInsets.all(8.0),
            itemCount: controller.activeOrders.length,
            itemBuilder: (context, index) {
              final order = controller.activeOrders[index];
              return _ActiveOrderItem(
                order: order,
                isCurrencyTL: controller.isCurrencyTL.value, // Pass currency flag
              );
            },
          );
        },
      ),
    );
  }
}

// Private widget for displaying a single order item - follows SRP
class _ActiveOrderItem extends StatelessWidget {
  final AlinanSiparisBilgileriL order;
  final bool isCurrencyTL; // Determine currency symbol

  const _ActiveOrderItem({
    required this.order,
    required this.isCurrencyTL,
  });

  @override
  Widget build(BuildContext context) {
    // Determine currency symbol based on isCurrencyTL
    // TODO: Enhance this logic if more currencies are needed
    final labels = AppLocalization.getLabels(context); // Get labels here too
    final currencySymbol = isCurrencyTL ? '₺' : '\$';  // Escaped dollar sign
    final totalAmount = order.tutar ?? 0.0; // Use 'tutar' for total amount
    final orderStatus = order.durum == true ? labels.statusActive : labels.statusPassive; // Example status mapping (Adjust based on actual meaning)
    final orderDate = order.tarih; // Order date

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 4.0),
      elevation: 2.0,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10.0)),
      child: ListTile(
        contentPadding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 16.0),
        leading: CircleAvatar(
          // Use a relevant icon or initial
          backgroundColor: Theme.of(context).colorScheme.primaryContainer,
          child: Icon(
            Icons.receipt_long,
            color: Theme.of(context).colorScheme.onPrimaryContainer,
          ),
        ),
        title: Text(
          // Use urunAdi or urunKodu if relevant, or a generic label
          order.urunAdi ?? labels.orderDetail, // Order Detail (fallback)
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text('${labels.productCodeLabel}${order.urunKodu ?? labels.notAvailable}'), // Product Code
             if (orderDate != null)
              // Removed redundant null check, outer if guarantees non-null
              Text('${labels.dateLabel}${/* Format Date */ orderDate.toString().substring(0, 10)}'), // Date
            Text('${labels.statusLabel}$orderStatus'), // Status
          ],
        ),
        trailing: Text(
          '$currencySymbol${totalAmount.toStringAsFixed(2)}',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 16,
            color: Theme.of(context).colorScheme.primary,
          ),
        ),
        // Optional: Add onTap for navigating to order details if needed
        // onTap: () {
        //   // Get.toNamed('/order-detail', arguments: order.id);
        // },
      ),
    );
  }
}
