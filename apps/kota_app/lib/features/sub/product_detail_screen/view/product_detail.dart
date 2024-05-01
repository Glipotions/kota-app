// ignore_for_file: omit_local_variable_types

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota_app/features/main/all_products_screen/view/components/add_to_cart_text.dart';
import 'package:kota_app/features/sub/product_detail_screen/controller/product_detail_controller.dart';
import 'package:kota_app/product/base/base_view.dart';
import 'package:kota_app/product/consts/general.dart';
import 'package:kota_app/product/managers/cart_controller.dart';
import 'package:kota_app/product/utility/enums/module_padding_enums.dart';
import 'package:kota_app/product/widgets/button/clickable_text.dart';
import 'package:kota_app/product/widgets/button/quantity_selection_button.dart';
import 'package:kota_app/product/widgets/card/bordered_image.dart';
import 'package:kota_app/product/widgets/chip/custom_choice_chip.dart';
import 'package:kota_app/product/widgets/other/stock_information.dart';
import 'package:values/values.dart';

class ProductDetail extends StatelessWidget {
  const ProductDetail({required this.controller, super.key});

  final ProductDetailController controller;

  @override
  Widget build(BuildContext context) {
    final CartController cartCont = Get.find();

    return Scaffold(
      key: controller.scaffoldKey,
      bottomSheet: Padding(
        padding: EdgeInsets.all(ModulePadding.s.value),
        child: SizedBox(
          width: double.infinity,
          child: Card(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                SizedBox(
                  height: ModulePadding.xxs.value,
                ),
                Row(
                  children: [
                    Expanded(
                      child: QuantitySelectionButton(
                        cController: controller.cQty,
                      ),
                    ),
                    SizedBox(
                      width: ModulePadding.xxs.value,
                    ),
                    Obx(
                      () => AddToCartText(
                        item: controller.cartProduct,
                        cCont: controller.cQty,
                      ),
                    ),
                    SizedBox(width: ModulePadding.xxs.value),
                  ],
                ),
                SizedBox(height: ModulePadding.xxs.value),
                Row(
                  children: [
                    Obx(
                      () => Row(
                        children: [
                          SizedBox(width: ModulePadding.xxs.value),
                          const Text(
                            'Sepetteki Adet:',
                            // style: context.bodyMedium
                            //     .copyWith(color: context.primary),
                          ),
                          Text(
                            cartCont
                                    .inChartItemById(
                                      controller.selectedProductVariant
                                              ?.productId ??
                                          0,
                                    )
                                    ?.quantity
                                    .toString() ??
                                '',
                            // style: context.bodyMedium
                            //     .copyWith(color: context.primary),
                          ),
                        ],
                      ).isVisible(
                        value: cartCont.inChartItemById(
                              controller.selectedProductVariant?.productId ?? 0,
                            ) !=
                            null,
                      ),
                    ),
                    const Spacer(),
                    Obx(
                      () => ClickableText(
                        text: 'Sepetten Kaldır',
                        onTap: () {
                          cartCont.onTapRemoveProduct(
                            CartProductModel(
                              id: controller.selectedProductVariant!.productId!,
                              code: controller.code,
                              name: controller.code,
                              price: controller.selectedUnitPrice!.value,
                              quantity: int.parse(controller.cQty.text),
                              pictureUrl: controller.product.pictureUrl ??
                                  baseLogoUrl,
                            ),
                          );
                        },
                        textStyle:
                            context.bodyMedium.copyWith(color: context.error),
                      ).isVisible(
                        value: cartCont.inChartItemById(
                              controller.selectedProductVariant?.productId ?? 0,
                            ) !=
                            null,
                      ),
                    ),
                    SizedBox(width: ModulePadding.xxs.value),
                  ],
                ),
                SizedBox(height: ModulePadding.s.value),
              ],
            ),
          ),
        ),
      ),
      appBar: AppBar(
        forceMaterialTransparency: true,
        title: const Text('Ürün Detayı'),
      ),
      body: BaseView<ProductDetailController>(
        controller: controller,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Obx(
              () => BorderedImage(
                radius: BorderRadius.zero,
                aspectRatio: 343 / 300,
                imageUrl: controller.product.pictureUrl ??
                    baseLogoUrl,
                // imageUrl: 'https://kota-app.b-cdn.net/1000-1.jpg',
                // imageUrl: 'https://thispersondoesnotexist.com/',
              ),
            ),
            SizedBox(height: ModulePadding.l.value),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: ModulePadding.s.value),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    controller.productCode,
                    style: context.titleLarge,
                  ),
                  Row(
                    children: [
                      const StockInformationWidget(isInStock: true),
                      SizedBox(
                        width: ModulePadding.xxs.value,
                      ),
                      Expanded(
                        child: Obx(
                          () => Text(
                            'Fiyat: ${controller.selectedUnitPrice}',
                            style: context.titleLarge,
                            textAlign: TextAlign.end,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            SizedBox(height: ModulePadding.l.value),
            Padding(
              padding: EdgeInsets.only(left: ModulePadding.s.value),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Renk Seçimi',
                  ),
                  SizedBox(
                    height: ModulePadding.xxs.value,
                  ),
                  SizedBox(
                    height: 35,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final list = controller.product.colors ?? [];
                        if (list.length <= index) {
                          return const SizedBox();
                        }
                        final item = list[index];

                        return Obx(
                          () => CustomChoiceChip(
                            title: item,
                            isSelected: index == controller.selectedColor.value,
                            onTap: () => controller.onTapColor(index),
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(
                        width: ModulePadding.xxs.value,
                      ),
                      itemCount: 35,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: ModulePadding.l.value),
            Padding(
              padding: EdgeInsets.only(left: ModulePadding.s.value),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    'Beden Seçimi',
                  ),
                  SizedBox(
                    height: ModulePadding.xxs.value,
                  ),
                  SizedBox(
                    height: 35,
                    child: ListView.separated(
                      scrollDirection: Axis.horizontal,
                      itemBuilder: (context, index) {
                        final list = controller.product.sizes ?? [];
                        if (list.length <= index) {
                          return const SizedBox();
                        }
                        final item = list[index];

                        return Obx(
                          () => CustomChoiceChip(
                            title: item,
                            isSelected: index == controller.selectedSize.value,
                            onTap: () => controller.onTapSize(index),
                            enabled: controller.sizeEnableCheck(index).value,
                          ),
                        );
                      },
                      separatorBuilder: (context, index) => SizedBox(
                        width: ModulePadding.xxs.value,
                      ),
                      itemCount: 10,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
