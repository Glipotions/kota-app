// ignore_for_file: omit_local_variable_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota_app/features/sub/product_detail_screen/controller/product_detail_controller.dart';
import 'package:kota_app/product/managers/cart_controller.dart';
import 'package:kota_app/product/utility/enums/module_padding_enums.dart';
import 'package:kota_app/product/widgets/app_bar/general_app_bar.dart';
import 'package:kota_app/product/widgets/button/quantity_selection_button.dart';
import 'package:kota_app/product/widgets/card/bordered_image.dart';
import 'package:kota_app/product/widgets/chip/custom_choice_chip.dart';
import 'package:kota_app/product/widgets/other/stock_information.dart';
import 'package:kota_app/features/main/all_products_screen/view/components/add_to_cart_text.dart';

class ProductDetail extends StatelessWidget {
  const ProductDetail({required this.controller, super.key});

  final ProductDetailController controller;

  @override
  Widget build(BuildContext context) {
    final CartController cartCont = Get.put(CartController());

    return GestureDetector(
      onTap: controller.unFocus,
      child: Scaffold(
        key: controller.scaffoldKey,
        appBar: GeneralAppBar(
          title: 'Ürün Detay: '+(controller.selectedProductVariant?.productCode ?? ''),
          // additionalIcon: IconButton(
          //   icon: const Icon(Icons.share),
          //   onPressed: () {
          //     // Share functionality
          //   },
          // ),
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
                      AspectRatio(
                        aspectRatio: 1,
                        child: PageView.builder(
                          itemCount: 1,
                          itemBuilder: (context, index) {
                            return Hero(
                              tag: 'product-${controller.code}',
                              child: Obx(() {
                                final imageUrl = controller.product.pictureUrl;
                                if (imageUrl == null || imageUrl.isEmpty) {
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
                            Obx(() => Text(
                                  controller.selectedProductVariant
                                          ?.productName ??
                                      '',
                                  style: Theme.of(context)
                                      .textTheme
                                      .headlineSmall
                                      ?.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                )),
                            const SizedBox(height: 8),
                            Obx(() => Text(
                                  '₺${controller.selectedUnitPrice?.value.toStringAsFixed(2) ?? "0.00"}',
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.copyWith(
                                        color: Theme.of(context).primaryColor,
                                        fontWeight: FontWeight.bold,
                                      ),
                                )),

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
                              if (colors == null || colors.isEmpty)
                                return const SizedBox();

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Renk Seçimi',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  SizedBox(
                                    height: 40,
                                    child: ListView.builder(
                                      scrollDirection: Axis.horizontal,
                                      itemCount: colors.length,
                                      itemBuilder: (context, index) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8),
                                          child: Obx(() => CustomChoiceChip(
                                                title: colors[index],
                                                isSelected: controller
                                                        .selectedColor.value ==
                                                    index,
                                                onTap: () => controller
                                                    .onTapColor(index),
                                              )),
                                        );
                                      },
                                    ),
                                  ),
                                ],
                              );
                            }),

                            const SizedBox(height: 16),

                            // Size Selection
                            Obx(() {
                              final sizes = controller.product.sizes;
                              if (sizes == null || sizes.isEmpty)
                                return const SizedBox();

                              return Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    'Beden Seçimi',
                                    style:
                                        Theme.of(context).textTheme.titleMedium,
                                  ),
                                  const SizedBox(height: 8),
                                  Wrap(
                                    spacing: 8,
                                    children: List.generate(
                                      sizes.length,
                                      (index) => Obx(() => CustomChoiceChip(
                                            title: sizes[index],
                                            isSelected:
                                                controller.selectedSize.value ==
                                                    index,
                                            onTap: () =>
                                                controller.onTapSize(index),
                                          )),
                                    ),
                                  ),
                                ],
                              );
                            }),

                            // Add padding at the bottom to account for the bottom sheet
                            SizedBox(
                                height:
                                    MediaQuery.of(context).size.height * 0.2),
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
