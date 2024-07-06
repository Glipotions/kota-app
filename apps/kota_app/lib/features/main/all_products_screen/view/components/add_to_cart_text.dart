import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota_app/product/managers/cart_controller.dart';
import 'package:kota_app/product/models/cart_product_model.dart';
import 'package:kota_app/product/widgets/button/clickable_text.dart';
import 'package:widgets/widget.dart';

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
    return Obx(
      () => ClickableText(
        text: cartCont.inChartItemById(item.id) != null
            ? 'Sepeti Güncelle'
            : 'Sepete Ekle',
        onTap: () {
          final qty = int.tryParse(cCont.text);
          if (item.id == 0) {
            ToastMessage.showToastMessage(
              message: 'Lütfen Renk ve Beden Seçiniz.',
              type: ToastMessageType.error,
            );
          } else {
            if (qty != null) {
              cCont.text = '0';
              if (qty == 0) {
                cartCont.onTapRemoveProduct(item.copyWith(quantity: 0));
              } else {
                cartCont.onTapAddProduct(item.copyWith(quantity: qty));
              }
              ToastMessage.showToastMessage(
                message: 'Ürün Sepete Eklendi',
                type: ToastMessageType.success,
              );
            } else {
              ToastMessage.showToastMessage(
                message: 'Lütfen geçerli bir adet giriniz.',
                type: ToastMessageType.error,
              );
            }
          }
        },
      ),
    );
  }
}
