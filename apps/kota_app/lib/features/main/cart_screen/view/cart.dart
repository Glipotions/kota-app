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

part 'components/product_card.dart';

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
                  () => CustomScrollView(
                    controller: _scrollController,
                    slivers: [
                      SliverToBoxAdapter(
                        child: AnimatedSwitcher(
                          duration: const Duration(milliseconds: 300),
                          child: controller.itemList.isEmpty
                              ? EmptyView(
                                  message: labels.emptyCartMessage,
                                )
                              : Padding(
                                  padding: EdgeInsets.all(ModulePadding.s.value),
                                  child: ListView.separated(
                                    physics: const NeverScrollableScrollPhysics(),
                                    shrinkWrap: true,
                                    padding: const EdgeInsets.only(
                                      bottom:
                                          180, // Add padding for the complete order section
                                    ),
                                    itemBuilder: (context, index) {
                                      final item = controller.itemList[index];
                                      return Dismissible(
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
                                        child: _ProductCard(
                                          item: item,
                                          onTapRemove: () =>
                                              controller.onTapRemoveProduct(item),
                                          isCurrencyTL: controller.isCurrencyTL,
                                        ),
                                      );
                                    },
                                    separatorBuilder: (_, __) => SizedBox(
                                      height: ModulePadding.s.value,
                                    ),
                                    itemCount: controller.itemList.length,
                                  ),
                                ),
                        ),
                      ),
                    ],
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
}
