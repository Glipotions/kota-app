// ignore_for_file: omit_local_variable_types, cascade_invocations

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
import 'package:values/values.dart';

extension SizeSortExtension on List<String>? {
  List<String> sortSizes() {
    if (this == null) return [];
    final sortedList = [
      ...?this
    ]; // Null-safe spread operator kullanarak kopyalama

    // Harfli bedenlerin sıralaması
    final letterSizes = {
      'XXS': 0,
      'XS': 1,
      'S': 2,
      'M': 3,
      'L': 4,
      'XL': 5,
      'XXL': 6,
      'S-M': 7, // Birleşik bedenler en sona
      'M-L': 8,
      'L-XL': 9,
      'XL-XXL': 10,
    };

    sortedList.sort((a, b) {
      final aIsLetter = letterSizes.containsKey(a);
      final bIsLetter = letterSizes.containsKey(b);

      // İkisi de harfli beden ise
      if (aIsLetter && bIsLetter) {
        return letterSizes[a]!.compareTo(letterSizes[b]!);
      }

      // Sadece biri harfli beden ise, harfli olan önce gelsin
      if (aIsLetter) return -1;
      if (bIsLetter) return 1;

      // İkisi de sayısal ise
      final aNumbers =
          a.split('-').map((e) => int.tryParse(e.trim()) ?? 0).toList();
      final bNumbers =
          b.split('-').map((e) => int.tryParse(e.trim()) ?? 0).toList();

      // İlk sayıları karşılaştır
      return aNumbers.first.compareTo(bNumbers.first);
    });

    return sortedList;
  }
}

extension ColorNameExtension on String {
  Color? toColor() {
    final normalizedColor = trim().toLowerCase();
    final colorMap = {
      'siyah': Colors.black,
      'beyaz': Colors.white,
      'kırmızı': Colors.red,
      'mavi': Colors.blue,
      'yeşil': Colors.green,
      'sarı': Colors.yellow,
      'turuncu': Colors.orange,
      'mor': Colors.purple,
      'pembe': Colors.pink,
      'kahverengi': Colors.brown,
      'gri': Colors.grey,
      'lacivert': const Color(0xFF000080),
      'bej': const Color(0xFFE8D6B3),
      'bordo': const Color(0xFF800000),
      'altın': const Color(0xFFFFD700),
      'gümüş': const Color(0xFFC0C0C0),
      'indigo': Colors.indigo,
      'füme': const Color(0xFF4A4A4A), // Koyu gri tonu
      'koyu yeşil': const Color(0xFF006400), // Dark green
    };
    return colorMap[normalizedColor];
  }
}

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
        appBar: const GeneralAppBar(
          title: 'Ürün Detay',
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
                            Obx(
                              () => Text(
                                controller.selectedUnitPrice?.value
                                        .formatPrice() ??
                                    '₺0,00',
                                style: Theme.of(context)
                                    .textTheme
                                    .titleLarge
                                    ?.copyWith(
                                      color: Theme.of(context).primaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                              ),
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
                                        final color = colors[index].toColor();
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 8),
                                          child: Obx(
                                            () => CustomChoiceChip(
                                              title: colors[index],
                                              isSelected: controller
                                                      .selectedColor.value ==
                                                  index,
                                              onTap: () =>
                                                  controller.onTapColor(index),
                                              backgroundColor: color,
                                              labelColor: color != null
                                                  ? (color == Colors.white
                                                      ? Colors.black
                                                      : Colors.white)
                                                  : null,
                                            ),
                                          ),
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
                              if (sizes == null || sizes.isEmpty) {
                                return const SizedBox();
                              }

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
