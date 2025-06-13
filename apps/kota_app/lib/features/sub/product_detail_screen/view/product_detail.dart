// ignore_for_file: omit_local_variable_types, cascade_invocations

import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota_app/features/main/all_products_screen/view/components/add_to_cart_text.dart';
import 'package:kota_app/features/sub/product_detail_screen/controller/product_detail_controller.dart';
import 'package:kota_app/product/managers/cart_controller.dart';
import 'package:kota_app/product/utility/enums/module_padding_enums.dart';
import 'package:kota_app/product/utility/enums/module_radius_enums.dart';
import 'package:kota_app/product/utility/extentions/price_display_extension.dart';
import 'package:kota_app/product/widgets/app_bar/general_app_bar.dart';
import 'package:kota_app/product/widgets/button/quantity_selection_button.dart';
import 'package:kota_app/product/widgets/card/bordered_image.dart';
import 'package:kota_app/product/widgets/chip/custom_choice_chip.dart';
import 'package:kota_app/product/widgets/other/stock_information.dart';

class ProductDetail extends StatelessWidget {
  const ProductDetail({required this.controller, super.key});

  final ProductDetailController controller;

  Widget _buildChip(
    BuildContext context,
    IconData icon,
    String text,
    Color bgColor,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ModulePadding.xs.value,
        vertical: ModulePadding.xxxs.value,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        borderRadius: BorderRadius.circular(ModuleRadius.s.value),
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
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: Colors.black87,
                  fontWeight: FontWeight.w500,
                ),
          ),
        ],
      ),
    );
  }

  void _showCartPopup(BuildContext context, CartController cartController) {
    final labels = AppLocalization.getLabels(context);
    final currentProductGroupId =
        controller.selectedProductVariant?.productCodeGroupId;
    if (currentProductGroupId == null) return;

    final cartItems = cartController.itemList
        .where((item) => item.productCodeGroupId == currentProductGroupId)
        .toList();

    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(labels.noProductInCart),
          duration: const Duration(seconds: 2),
        ),
      );
      return;
    }

    showModalBottomSheet(
      context: context,
      constraints: BoxConstraints(
        maxHeight: MediaQuery.of(context).size.height * 0.7,
      ),
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
      ),
      builder: (context) => Container(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Row(
                    children: [
                      Text(
                        labels.productsInCart,
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(width: 8),
                      Obx(() {
                        final totalQuantity = cartController.itemList
                            .where((item) =>
                                item.productCodeGroupId ==
                                currentProductGroupId)
                            .fold<int>(
                                0, (sum, item) => sum + (item.quantity ?? 0));

                        return Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 12,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color:
                                Theme.of(context).primaryColor.withOpacity(0.1),
                            borderRadius: BorderRadius.circular(20),
                            border: Border.all(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.3),
                              width: 1,
                            ),
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                Icons.shopping_bag_outlined,
                                size: 16,
                                color: Theme.of(context).primaryColor,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                '$totalQuantity ${labels.piece}',
                                style: Theme.of(context)
                                    .textTheme
                                    .bodyMedium
                                    ?.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ],
                          ),
                        );
                      }),
                    ],
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            const Divider(),
            Flexible(
              child: SingleChildScrollView(
                child: Obx(() {
                  final updatedCartItems = cartController.itemList
                      .where((item) =>
                          item.productCodeGroupId == currentProductGroupId)
                      .toList();

                  if (updatedCartItems.isEmpty) {
                    Navigator.pop(context);
                    return const SizedBox();
                  }

                  return Column(
                    children: [
                      ...updatedCartItems.map(
                        (item) => Padding(
                          padding: const EdgeInsets.symmetric(vertical: 8),
                          child: Card(
                            elevation: 2,
                            child: Padding(
                              padding: EdgeInsets.all(ModulePadding.xs.value),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Wrap(
                                      spacing: ModulePadding.xxs.value,
                                      children: [
                                        _buildChip(
                                          context,
                                          Icons.local_offer,
                                          item.code!,
                                          Colors.grey.shade100,
                                        ),
                                        if (item.sizeName != null)
                                          _buildChip(
                                            context,
                                            Icons.straighten,
                                            item.sizeName!,
                                            Colors.blue.shade50,
                                          ),
                                        if (item.colorName != null)
                                          _buildChip(
                                            context,
                                            Icons.palette_outlined,
                                            item.colorName!,
                                            Colors.orange.shade50,
                                          ),
                                      ],
                                    ),
                                  ),
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
                                          borderRadius: BorderRadius.circular(
                                              ModuleRadius.s.value),
                                        ),
                                        child: Text(
                                          '${item.quantity}x',
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleSmall
                                              ?.copyWith(
                                                color: Theme.of(context)
                                                    .primaryColor,
                                                fontWeight: FontWeight.bold,
                                              ),
                                        ),
                                      ),
                                      IconButton(
                                        icon: const Icon(Icons.delete_outline,
                                            color: Colors.red),
                                        onPressed: () {
                                          showDialog(
                                            context: context,
                                            builder: (BuildContext context) {
                                              return AlertDialog(
                                                backgroundColor: Colors.white,
                                                shape: RoundedRectangleBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(15),
                                                ),
                                                title: Text(
                                                  labels.removeProduct,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .titleLarge
                                                      ?.copyWith(
                                                        color: Colors.black87,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                ),
                                                content: Text(
                                                  labels.removeProductConfirm,
                                                  style: Theme.of(context)
                                                      .textTheme
                                                      .bodyMedium
                                                      ?.copyWith(
                                                        color: Colors.black87,
                                                      ),
                                                ),
                                                actions: [
                                                  TextButton(
                                                    style: TextButton.styleFrom(
                                                      foregroundColor:
                                                          Colors.grey[700],
                                                    ),
                                                    child: Text(
                                                      labels.cancel,
                                                      style: const TextStyle(
                                                          fontWeight:
                                                              FontWeight.w500),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                    },
                                                  ),
                                                  TextButton(
                                                    style: TextButton.styleFrom(
                                                      foregroundColor:
                                                          Colors.red,
                                                    ),
                                                    child: Text(
                                                      labels.remove,
                                                      style: const TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    onPressed: () {
                                                      Navigator.of(context)
                                                          .pop();
                                                      cartController
                                                          .onTapRemoveProduct(
                                                              item);
                                                    },
                                                  ),
                                                ],
                                              );
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  );
                }),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final labels = AppLocalization.getLabels(context);
    final CartController cartCont = Get.put(CartController());

    return GestureDetector(
      onTap: controller.unFocus,
      child: Scaffold(
        key: controller.scaffoldKey,
        appBar: GeneralAppBar(
          title: labels.productDetail,
          additionalIcon: IconButton(
            icon: const Icon(Icons.shopping_basket_outlined),
            onPressed: () => _showCartPopup(context, cartCont),
          ),
        ),
        body: Stack(
          children: [
            CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Image Carousel
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.35,
                        child: PageView.builder(
                          itemCount: 1,
                          itemBuilder: (context, index) {
                            return Hero(
                              tag: 'product-${controller.code}',
                              child: Obx(() {
                                final imageUrl =
                                    controller.getSelectedProductImageUrl();
                                if (imageUrl.isEmpty) {
                                  return Container(
                                    color: Colors.grey[200],
                                    child: const Center(
                                      child: Icon(
                                        Icons.image_not_supported_outlined,
                                        size: 48,
                                        color: Colors.grey,
                                      ),
                                    ),
                                  );
                                }
                                return BorderedImage(
                                  imageUrl: imageUrl,
                                  radius: BorderRadius.zero,
                                  fit: BoxFit.contain,
                                );
                              }),
                            );
                          },
                        ),
                      ),

                      Padding(
                        padding: EdgeInsets.all(ModulePadding.m.value),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Product Name and Price
                            Obx(
                              () => Text(
                                controller
                                        .selectedProductVariant?.productName ??
                                    '',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineSmall
                                    ?.copyWith(
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
                            ),
                            const SizedBox(height: 8),

                            // Product Code Display
                            Obx(() {
                              // Only show product code when both color and size are selected
                              final isColorSelected =
                                  controller.selectedColor.value >= 0;
                              final isSizeSelected =
                                  controller.selectedSize.value >= 0;
                              final productCode = controller
                                  .selectedProductVariant?.productCode;

                              if (!isColorSelected ||
                                  !isSizeSelected ||
                                  productCode == null ||
                                  productCode.isEmpty) {
                                return const SizedBox();
                              }

                              return _buildChip(
                                context,
                                Icons.local_offer,
                                productCode,
                                Colors.grey.shade100,
                              );
                            }),
                            const SizedBox(height: 8),
                            Obx(
                              () {
                                final cartController =
                                    Get.find<CartController>();
                                final originalPrice =
                                    controller.showUnitPrice?.value ?? 0.0;
                                final hasDiscount =
                                    cartController.cartDiscountRate.value > 0;

                                if (hasDiscount) {
                                  final discountRate =
                                      cartController.cartDiscountRate.value;
                                  final discountedPrice =
                                      originalPrice * (1 - discountRate / 100);

                                  return PriceDisplayHelper
                                      .buildDiscountedPriceWidget(
                                    context,
                                    originalPrice: originalPrice,
                                    discountedPrice: discountedPrice,
                                    discountRate: discountRate,
                                    originalPriceStyle:
                                        Theme.of(context).textTheme.titleLarge,
                                    discountedPriceStyle: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                    discountBadgeStyle:
                                        Theme.of(context).textTheme.bodySmall,
                                    placeholderStyle: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  );
                                } else {
                                  return PriceDisplayHelper.buildPriceWidget(
                                    context,
                                    price: originalPrice,
                                    priceStyle: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                    placeholderStyle: Theme.of(context)
                                        .textTheme
                                        .titleLarge
                                        ?.copyWith(
                                          color: Theme.of(context).primaryColor,
                                          fontWeight: FontWeight.bold,
                                        ),
                                  );
                                }
                              },
                            ),

                            const SizedBox(height: 16),

                            // Stock Information
                            Obx(
                              () => StockInformationWidget(
                                isInStock:
                                    (controller.selectedProductVariant?.stock ??
                                            0) >
                                        0,
                              ),
                            ),

                            const SizedBox(height: 16),

                            // Color Selection
                            Obx(() {
                              final colors = controller.product.colors;
                              if (colors == null || colors.isEmpty) {
                                return const SizedBox();
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    labels.colorSelection,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    children: List.generate(
                                      colors.length,
                                      (index) => Obx(
                                        () => CustomChoiceChip(
                                          title: colors[index],
                                          isSelected:
                                              controller.selectedColor.value ==
                                                  index,
                                          onTap: () =>
                                              controller.onTapColor(index),
                                        ),
                                      ),
                                    ),
                                  ),
                                ],
                              );
                            }),

                            const SizedBox(height: 16),

                            // Size Selection
                            Obx(() {
                              final sizes = controller.product.sizes;
                              if (sizes == null || sizes.isEmpty) {
                                return const SizedBox();
                              }

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    labels.sizeSelection,
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    children: List.generate(
                                      sizes.sortSizes().length,
                                      (index) {
                                        final sortedSizes = sizes.sortSizes();
                                        final currentSize = sortedSizes[index];
                                        final originalIndex =
                                            sizes.indexOf(currentSize);
                                        return Obx(
                                          () => CustomChoiceChip(
                                            title: currentSize,
                                            isSelected:
                                                controller.selectedSize.value ==
                                                    originalIndex,
                                            onTap: () => controller
                                                .onTapSize(originalIndex),
                                          ),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }),

                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.2,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            Positioned(
              left: 0,
              right: 0,
              bottom: ModulePadding.m.value,
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 12,
                  vertical: 8,
                ),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.1),
                      blurRadius: 10,
                      offset: const Offset(0, -2),
                    ),
                  ],
                ),
                child: Row(
                  children: [
                    Expanded(
                      flex: 3,
                      child: QuantitySelectionButton(
                        cController: controller.cQty,
                        productCountInPackage: controller
                            .selectedProductVariant?.productCountInPackage,
                      ),
                    ),
                    const SizedBox(width: 8),
                    Expanded(
                      flex: 4,
                      child: AddToCartText(
                        item: controller.cartProduct,
                        cCont: controller.cQty,
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
