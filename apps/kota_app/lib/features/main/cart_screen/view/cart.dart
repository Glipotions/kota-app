// ignore_for_file: lines_longer_than_80_chars

import 'dart:async';

import 'package:common/common.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota_app/features/main/cart_screen/controller/cart_pdf_controller.dart';
import 'package:kota_app/product/managers/cart_controller.dart';
import 'package:kota_app/product/models/cart_product_model.dart';
import 'package:kota_app/product/utility/enums/module_padding_enums.dart';
import 'package:kota_app/product/utility/enums/module_radius_enums.dart';
import 'package:kota_app/product/utility/extentions/num_extension.dart';
import 'package:kota_app/product/widgets/button/module_button.dart';
import 'package:kota_app/product/widgets/card/bordered_image.dart';
import 'package:kota_app/product/widgets/other/empty_view.dart';
import 'package:values/values.dart';

// part 'components/product_card.dart'; // Removed to inline the component

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
    // Update currency values every time the Cart screen is opened
    final cartController = Get.find<CartController>();
    cartController.updateCurrencyValues();

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

      // Handle lazy loading for pagination
      if (currentScroll >= maxScroll - 200) {
        cartController.loadMoreItems();
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

  void _scrollToTop() {
    _scrollController.animateTo(
      0,
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
    );
  }

  Future<void> _showClearCartDialog(
    BuildContext context,
    CartController controller,
  ) async {
    final labels = AppLocalization.getLabels(context);
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          backgroundColor: Theme.of(context).cardColor,
          title: Text(
            labels.clearCart,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          content: Text(
            labels.clearCartConfirmation,
            style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                  color: Theme.of(context).colorScheme.onSurface,
                ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                labels.cancel,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primary,
                ),
              ),
              onPressed: () => Navigator.of(context).pop(),
            ),
            TextButton(
              child: Text(
                labels.clear,
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

  Future<void> _generateAndOpenPdf(
    BuildContext context,
    List<CartProductModel> products,
    CartController controller,
  ) async {
    final pdfController = CartPdfController();
    await pdfController.generateAndOpenCartPdf(context, products, controller);
  }

  /// Debug method to populate cart with test items for testing chunking functionality
  Future<void> _populateCartWithTestItems(BuildContext context, CartController controller) async {
    final labels = AppLocalization.getLabels(context);

    // Show confirmation dialog
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Debug: Add Test Items'),
          content: const Text(
            'This will add 500 test items to your cart for testing purposes. '
            'This will clear your current cart first. Continue?'
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(labels.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: const Text('Add Test Items'),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    // Show progress dialog
    unawaited(showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return const AlertDialog(
          content: Row(
            children: [
              CircularProgressIndicator(),
              SizedBox(width: 20),
              Text('Adding test items...'),
            ],
          ),
        );
      },
    ),);

    try {
      // Clear existing cart
      await controller.clearCart();

      // Generate test data
      final testItems = _generateTestCartItems();

      // Add items to cart (simulate adding one by one with small delay for realism)
      for (var i = 0; i < testItems.length; i++) {
        controller.onTapAddProduct(testItems[i]);

        // Add small delay every 50 items to prevent UI blocking
        if (i % 50 == 0) {
          await Future<void>.delayed(const Duration(milliseconds: 10));
        }
      }

      // Close progress dialog
      if (context.mounted) {
        Navigator.pop(context);

        // Show success message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Added ${testItems.length} test items to cart'),
            backgroundColor: Colors.green,
          ),
        );
      }
    } catch (e) {
      // Close progress dialog
      if (context.mounted) {
        Navigator.pop(context);

        // Show error message
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Error adding test items: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  /// Generates 500 test cart items with realistic data
  List<CartProductModel> _generateTestCartItems() {
    final testItems = <CartProductModel>[];

    // Product categories for realistic names
    final categories = ['Shirt', 'Pants', 'Dress', 'Jacket', 'Skirt', 'Blouse', 'Sweater', 'Coat'];
    final materials = ['Cotton', 'Silk', 'Wool', 'Linen', 'Polyester', 'Denim', 'Leather'];
    final styles = ['Classic', 'Modern', 'Vintage', 'Casual', 'Formal', 'Sport', 'Elegant'];
    final sizes = ['XS', 'S', 'M', 'L', 'XL', 'XXL', '36', '38', '40', '42', '44', '46'];
    final colors = [
      'Black', 'White', 'Navy', 'Gray', 'Brown', 'Beige', 'Red', 'Blue',
      'Green', 'Yellow', 'Pink', 'Purple', 'Orange', 'Maroon', 'Khaki',
    ];

    for (var i = 1; i <= 500; i++) {
      final category = categories[i % categories.length];
      final material = materials[i % materials.length];
      final style = styles[i % styles.length];
      final size = sizes[i % sizes.length];
      final color = colors[i % colors.length];

      // Generate realistic prices (between 50-500)
      final basePrice = 50.0 + (i % 450);
      final currencyPrice = basePrice * 0.85; // Slightly different currency price

      // Generate quantities (1-10)
      final quantity = 1 + (i % 10);

      // Group products (every 10 products in same group for testing grouping)
      final groupId = (i / 10).floor();

      final testItem = CartProductModel(
        id: 1000 + i, // Start from 1000 to avoid conflicts
        code: 'TEST${i.toString().padLeft(3, '0')}',
        name: '$style $material $category',
        price: basePrice,
        currencyUnitPrice: currencyPrice,
        quantity: quantity,
        sizeName: size,
        colorName: color,
        productCodeGroupId: groupId,
        pictureUrl: 'https://placehold.jp/150x150.png',
      );

      testItems.add(testItem);
    }

    return testItems;
  }

  @override
  Widget build(BuildContext context) {
    final labels = AppLocalization.getLabels(context);

    return GetBuilder<CartController>(
      builder: (controller) {
        return Scaffold(
          key: controller.scaffoldKey,
          appBar: AppBar(
            title: Text(labels.cart),
            actions: [
              // Debug button - only visible in debug mode
              if (kDebugMode)
                IconButton(
                  icon: const Icon(Icons.bug_report, color: Colors.orange),
                  tooltip: 'Add 500 test items',
                  onPressed: () => _populateCartWithTestItems(context, controller),
                ),
              if (controller.itemList.isNotEmpty)
                IconButton(
                  icon: const Icon(Icons.picture_as_pdf),
                  onPressed: () =>
                      _generateAndOpenPdf(context, controller.itemList, controller),
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
                            Column(
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      labels.totalAmount,
                                      style: context.titleMedium,
                                    ),
                                    Obx(
                                      () => controller.cartDiscountRate.value > 0
                                          ? Column(
                                              crossAxisAlignment: CrossAxisAlignment.end,
                                              children: [
                                                Text(
                                                  controller.totalAmount(withDiscount: false).formatPrice(),
                                                  style: context.titleMedium.copyWith(
                                                    decoration: TextDecoration.lineThrough,
                                                    color: Colors.grey,
                                                  ),
                                                ),
                                                const SizedBox(height: 4),
                                                Text(
                                                  controller.totalAmount().formatPrice(),
                                                  style: context.headlineSmall.copyWith(
                                                    fontWeight: FontWeight.bold,
                                                    color: Theme.of(context).primaryColor,
                                                  ),
                                                ),
                                              ],
                                            )
                                          : Text(
                                              controller.totalAmount().formatPrice(),
                                              style: context.headlineSmall.copyWith(
                                                fontWeight: FontWeight.bold,
                                                color: Theme.of(context).primaryColor,
                                              ),
                                            ),
                                    ),
                                  ],
                                ),

                                // Show discount information if discount is applied
                                Obx(() => controller.cartDiscountRate.value > 0
                                  ? Padding(
                                      padding: EdgeInsets.only(top: ModulePadding.xs.value),
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                        children: [
                                          Text(
                                            'İndirim (%${controller.cartDiscountRate.value.toStringAsFixed(2)}):',
                                            style: context.titleSmall.copyWith(
                                              color: Colors.red,
                                            ),
                                          ),
                                          Text(
                                            '- ${controller.discountAmount().formatPrice()}',
                                            style: context.titleSmall.copyWith(
                                              color: Colors.red,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                        ],
                                      ),
                                    )
                                  : const SizedBox.shrink(),
                                ),

                                // Show discount input field for admin users
                                if (controller.hasAdminRights)
                                  Padding(
                                    padding: EdgeInsets.only(top: ModulePadding.s.value),
                                    child: Row(
                                      children: [
                                        Icon(
                                          Icons.discount_outlined,
                                          color: Theme.of(context).primaryColor,
                                        ),
                                        SizedBox(width: ModulePadding.xs.value),
                                        Text(
                                          'İskonto Oranı (%):',
                                          style: context.titleSmall,
                                        ),
                                        SizedBox(width: ModulePadding.s.value),
                                        Expanded(
                                          child: TextField(
                                            controller: controller.discountController,
                                            keyboardType: const TextInputType.numberWithOptions(decimal: true),
                                            decoration: InputDecoration(
                                              hintText: '0-100',
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.circular(
                                                  ModuleRadius.s.value,
                                                ),
                                              ),
                                              contentPadding: EdgeInsets.symmetric(
                                                horizontal: ModulePadding.s.value,
                                                vertical: ModulePadding.xs.value,
                                              ),
                                              suffixText: '%',
                                            ),
                                            onChanged: controller.updateDiscountRate,
                                            onEditingComplete: () {
                                              // Force keyboard to dismiss
                                              FocusScope.of(context).unfocus();
                                              FocusManager.instance.primaryFocus?.unfocus();
                                            },
                                            onTapOutside: (_) {
                                              // Dismiss keyboard when tapping outside
                                              FocusScope.of(context).unfocus();
                                            },
                                            textInputAction: TextInputAction.done,
                                          ),
                                        ),
                                      ],
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
                                        labels.orderNote,
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
                                        hintText: labels.addOrderNote,
                                        border: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(
                                            ModuleRadius.s.value,
                                          ),
                                        ),
                                      ),
                                      maxLines: 3,
                                      onEditingComplete: () {
                                        // Force keyboard to dismiss
                                        FocusScope.of(context).unfocus();
                                        FocusManager.instance.primaryFocus?.unfocus();
                                      },
                                      onTapOutside: (_) {
                                        // Dismiss keyboard when tapping outside
                                        FocusScope.of(context).unfocus();
                                      },
                                      textInputAction: TextInputAction.done,
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
                                onTap: () => controller.completeOrder(context),
                                title: controller.editingOrderId?.value != 0
                                    ? labels.updateOrder
                                    : labels.completeOrder,
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
          body: GestureDetector(
            onTap: () => FocusScope.of(context).unfocus(),
            behavior: HitTestBehavior.opaque,
            child: Stack(
              children: [
                Obx(
                  () => controller.itemList.isEmpty
                      ? EmptyView(
                          message: labels.emptyCartMessage,
                        )
                      : ListView.builder(
                          controller: _scrollController,
                          padding: EdgeInsets.only(
                            left: ModulePadding.s.value,
                            right: ModulePadding.s.value,
                            top: ModulePadding.s.value,
                            bottom: 200, // Add padding for the complete order section
                          ),
                          itemCount: controller.displayedItems.length +
                              (controller.hasMoreItems ? 1 : 0),
                          itemBuilder: (context, index) {
                            // Show loading indicator at the end if there are more items
                            if (index == controller.displayedItems.length) {
                              return Padding(
                                padding: EdgeInsets.all(ModulePadding.m.value),
                                child: const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                            }

                            final item = controller.displayedItems[index];
                            return Padding(
                              padding: EdgeInsets.only(
                                bottom: ModulePadding.s.value,
                              ),
                              child: Dismissible(
                                key: Key(item.id.toString()),
                                direction: DismissDirection.endToStart,
                                background: Container(
                                  alignment: Alignment.centerRight,
                                  padding: EdgeInsets.only(
                                    right: ModulePadding.m.value,
                                  ),
                                  color: Colors.red,
                                  child: const Icon(
                                    Icons.delete_outline,
                                    color: Colors.white,
                                  ),
                                ),
                                onDismissed: (_) =>
                                    controller.onTapRemoveProduct(item),
                                child: _buildProductCard(
                                  context,
                                  item,
                                  () => controller.onTapProductDetail(item),
                                  () => controller.onTapRemoveProduct(item),
                                  controller.isCurrencyTL,
                                ),
                              ),
                            );
                          },
                        ),
                ),
                if (_showScrollButton)
                  Positioned(
                    right: ModulePadding.m.value,
                    bottom: ModulePadding.m.value + 180,
                    child: FloatingActionButton(
                      mini: true,
                      onPressed: _scrollToTop,
                      child: const Icon(Icons.keyboard_arrow_up),
                    ),
                  ),
                if (_showScrollButton)
                  Positioned(
                    right: ModulePadding.m.value,
                    bottom: ModulePadding.m.value,
                    child: FloatingActionButton(
                      mini: true,
                      onPressed: _scrollToBottom,
                      child: const Icon(Icons.keyboard_arrow_down),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildProductCard(
    BuildContext context,
    CartProductModel item,
    VoidCallback? onTap,
    VoidCallback? onTapRemove,
    bool isCurrencyTL,
  ) {
    return Card(
      elevation: 2,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(ModuleRadius.m.value),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _ProductImage(
            item: item,
            radius: ModuleRadius.m.value,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.all(ModulePadding.xs.value),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Make only the product name clickable
                  InkWell(
                    onTap: onTap,
                    borderRadius: BorderRadius.circular(ModuleRadius.xs.value),
                    child: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: ModulePadding.xxxs.value,
                        vertical: ModulePadding.xxxs.value,
                      ),
                      child: Text(
                        item.name!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.labelMedium.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).primaryColor,
                          decoration: TextDecoration.underline,
                        ),
                      ),
                    ),
                  ),
                  if (item.sizeName != null || item.colorName != null)
                    Padding(
                      padding: EdgeInsets.only(top: ModulePadding.xxs.value),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          SingleChildScrollView(
                            scrollDirection: Axis.horizontal,
                            child: Row(
                              children: [
                                _buildChip(
                                  context,
                                  Icons.local_offer,
                                  item.code,
                                  Colors.grey.shade100,
                                ),
                                SizedBox(width: ModulePadding.xxs.value),
                                if (item.sizeName != null)
                                  _buildChip(
                                    context,
                                    Icons.straighten,
                                    item.sizeName!,
                                    Colors.blue.shade50,
                                  ),
                              ],
                            ),
                          ),
                          if (item.colorName != null)
                            SingleChildScrollView(
                              scrollDirection: Axis.horizontal,
                              child: Padding(
                                padding: EdgeInsets.only(
                                  top: ModulePadding.xxs.value,
                                ),
                                child: _buildChip(
                                  context,
                                  Icons.palette_outlined,
                                  item.colorName!,
                                  Colors.orange.shade50,
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  SizedBox(height: ModulePadding.xs.value),
                  Row(
                    children: [
                      Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: ModulePadding.xs.value,
                          vertical: ModulePadding.xxxs.value,
                        ),
                        decoration: BoxDecoration(
                          color: Theme.of(context)
                              .primaryColor
                              .withOpacity(0.1),
                          borderRadius:
                              BorderRadius.circular(ModuleRadius.s.value),
                        ),
                        child: Text(
                          '${item.quantity}x',
                          style: context.titleSmall.copyWith(
                            color: Theme.of(context).primaryColor,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ),
                      SizedBox(width: ModulePadding.xs.value),
                      Expanded(
                        child: item.discountRate > 0
                            ? Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    isCurrencyTL
                                        ? item.price.formatPrice()
                                        : item.currencyUnitPrice!.formatPrice(),
                                    style: context.labelSmall.copyWith(
                                      decoration: TextDecoration.lineThrough,
                                      color: Colors.grey,
                                    ),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                  Text(
                                    isCurrencyTL
                                        ? (item.price * (1 - item.discountRate / 100)).formatPrice()
                                        : (item.currencyUnitPrice! * (1 - item.discountRate / 100)).formatPrice(),
                                    style: context.titleSmall,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              )
                            : Text(
                                isCurrencyTL
                                    ? item.price.formatPrice()
                                    : item.currencyUnitPrice!.formatPrice(),
                                style: context.titleSmall,
                                overflow: TextOverflow.ellipsis,
                              ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChip(
    BuildContext context,
    IconData icon,
    String text,
    Color bgColor,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ModulePadding.xxxs.value,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
        borderRadius: BorderRadius.circular(ModuleRadius.xs.value),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: Colors.black87,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: context.labelSmall.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

/// Optimized product image widget for better performance
class _ProductImage extends StatelessWidget {
  const _ProductImage({
    required this.item,
    required this.radius,
  });

  final CartProductModel item;
  final double radius;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 100,
      height: 100,
      child: Hero(
        tag: 'product_${item.id}',
        child: ClipRRect(
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(radius),
            bottomLeft: Radius.circular(radius),
          ),
          child: BorderedImage(
            radius: BorderRadius.only(
              bottomLeft: Radius.circular(radius),
              topLeft: Radius.circular(radius),
            ),
            aspectRatio: 1,
            imageUrl: item.pictureUrl ?? 'https://kota-app.b-cdn.net/logo.jpg',
          ),
        ),
      ),
    );
  }
}
