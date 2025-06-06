import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota_app/product/managers/cart_controller.dart';
import 'package:kota_app/product/models/cart_product_model.dart';
import 'package:widgets/widget.dart';
import 'modern_cart_button.dart';

class AddToCartText extends StatelessWidget {
  const AddToCartText({
    required this.item,
    required this.cCont,
    super.key,
  });

  final CartProductModel item;
  final TextEditingController cCont;

  @override
  Widget build(BuildContext context) {
    final cartCont = Get.find<CartController>();
    final labels = AppLocalization.getLabels(context);
    return Obx(
      () => ModernCartButton(
        text: cartCont.inChartItemById(item.id) != null
            ? labels.updateCart
            : labels.addToCart,
        icon: Icons.shopping_cart_outlined,
        onTap: () {
          final qty = int.tryParse(cCont.text);
          if (item.id == 0) {
            ToastMessage.showToastMessage(
              message: labels.selectColorAndSize,
              type: ToastMessageType.error,
            );
          } else {
            if (qty != null) {
              // cCont.text = '0';
              if (qty == 0) {
                cartCont.onTapRemoveProduct(item.copyWith(quantity: 0));
              } else {
                cartCont.onTapAddProduct(item.copyWith(quantity: qty));
              }
              ToastMessage.showToastMessage(
                message: labels.productAddedToCart,
                type: ToastMessageType.success,
              );
            } else {
              ToastMessage.showToastMessage(
                message: labels.enterValidQuantity,
                type: ToastMessageType.error,
              );
            }
          }
        },
      ),
    );
  }
}
