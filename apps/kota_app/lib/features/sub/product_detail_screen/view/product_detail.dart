// ignore_for_file: omit_local_variable_types, cascade_invocations

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota_app/features/sub/product_detail_screen/controller/product_detail_controller.dart';
import 'package:kota_app/product/managers/cart_controller.dart';
import 'package:kota_app/product/utility/enums/module_padding_enums.dart';
import 'package:kota_app/product/utility/enums/module_radius_enums.dart';
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
      // Temel Renkler
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
      
      // Özel Renkler
      'lacivert': const Color(0xFF000080),
      'koyu mavi': const Color(0xFF000080),
      'bej': const Color(0xFFE8D6B3),
      'bordo': const Color(0xFF800000),
      'altın': const Color(0xFFFFD700),
      'gümüş': const Color(0xFFC0C0C0),
      'indigo': const Color(0xFF3F51B5),
      'füme': const Color(0xFF4A4A4A),
      'açık füme': const Color(0xFF6B6B6B),
      'koyu yeşil': const Color(0xFF006400),
      'petrol yeşili': const Color(0xFF004D40),
      'çağla yeşili': const Color(0xFF7CB342),
      'mint yeşili': const Color(0xFF98FF98),
      'haki': const Color(0xFF4B5320),
      
      // Gri Tonları
      'gri melanj': const Color(0xFF9E9E9E),
      'kar melanj': const Color(0xFFE0E0E0),
      'antrasit': const Color(0xFF383838),
      'taş gri': const Color(0xFF9E9E9E),
      'duman gri': const Color(0xFF696969),
      
      // Kırmızı/Pembe Tonları
      'fuşya': const Color(0xFFFF1493),
      'nar': const Color(0xFFDC143C),
      'nar çiçeği': const Color(0xFFFF69B4),
      'gül kurusu': const Color(0xFFDC6B6B),
      'vişne': const Color(0xFF800020),
      'pudra': const Color(0xFFFFC0CB),
      'somon': const Color(0xFFFA8072),
      
      // Bej/Kahve Tonları
      'krem': const Color(0xFFFFFDD0),
      'ekru': const Color(0xFFF5F5DC),
      'sütlü kahve': const Color(0xFF987654),
      'hardal': const Color(0xFFFFDB58),
      'kiremir': const Color(0xFFDEB887),
      'vizon': const Color(0xFF967969),
      'ten': const Color(0xFFFFE4C4),
      
      // Mavi Tonları
      'sax mavisi': const Color(0xFF4F97D1),
      'bebe mavi': const Color(0xFF89CFF0),
      'mavi&gri': const Color(0xFF607D8B),
      'infinity': const Color(0xFF1560BD),
      
      // Mor Tonları
      'lila': const Color(0xFFC8A2C8),
      'mürdüm': const Color(0xFF4B0082),
      'açık mürdüm': const Color(0xFF800080),
      
      // Desenli/Karışık
      'leopar': const Color(0xFFD2691E),
      'leopar baskılı': const Color(0xFFD2691E),
      'baskılı': Colors.grey,
      'asortili': Colors.grey,
      'baski asortili': Colors.grey,
      'renk asortili': Colors.grey,
      
      // Özel Karışımlar için varsayılan renk
      'asortili(açik mürdüm-ten-gri)': Colors.grey,
      'asortili(çağla yeşili-gül kurusu-mavi&gri)': Colors.grey,
      'asortili(gül kurusu / açik füme / açik mürdüm)': Colors.grey,
      'asortili(lacivert-bordo-mor)': Colors.grey,
      'asortili(lacivert-pembe-şeftali-lila-kirmizi-bordo)': Colors.grey,
      'asortili(mavi&gri / çağla yeşili / pembe)': Colors.grey,
      'asortili(pembe-ekru-şeftali)': Colors.grey,
      'asortili(siyah-beyaz-gri-ten)': Colors.grey,
      
      // Şeftali ve diğer renkler
      'şeftali': const Color(0xFFFFDAB9),
    };
    return colorMap[normalizedColor];
  }
}

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
    final currentProductGroupId = controller.selectedProductVariant?.productCodeGroupId;
    if (currentProductGroupId == null) return;

    final cartItems = cartController.itemList
        .where((item) => item.productCodeGroupId == currentProductGroupId)
        .toList();

    if (cartItems.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Bu üründen sepetinizde bulunmamaktadır.'),
          duration: Duration(seconds: 2),
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
                Text(
                  'Sepetteki Ürünler',
                  style: Theme.of(context).textTheme.titleLarge,
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
                child: Column(
                  children: [
                    ...cartItems.map((item) => Padding(
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
                              Container(
                                padding: EdgeInsets.symmetric(
                                  horizontal: ModulePadding.xs.value,
                                  vertical: ModulePadding.xxxs.value,
                                ),
                                decoration: BoxDecoration(
                                  color: Theme.of(context).primaryColor.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(ModuleRadius.s.value),
                                ),
                                child: Text(
                                  '${item.quantity}x',
                                  style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                    color: Theme.of(context).primaryColor,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )).toList(),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final CartController cartCont = Get.put(CartController());

    return GestureDetector(
      onTap: controller.unFocus,
      child: Scaffold(
        key: controller.scaffoldKey,
        appBar: GeneralAppBar(
          title: 'Ürün Detay',
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
