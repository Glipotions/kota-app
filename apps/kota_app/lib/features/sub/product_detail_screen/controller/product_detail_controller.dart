import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota_app/product/base/controller/base_controller.dart';
import 'package:kota_app/product/consts/general.dart';
import 'package:kota_app/product/managers/cart_controller.dart';

class ProductDetailController extends BaseControllerInterface {
  ProductDetailController({required this.code, required this.productCode});

  final Rx<ProductVariantResponseModel> _product =
      Rx(ProductVariantResponseModel());

  ProductVariantResponseModel get product => _product.value;
  set product(ProductVariantResponseModel value) => _product.value = value;

  final Rx<ProductVariant> _selectedProductVariant = Rx(ProductVariant());
  ProductVariant? get selectedProductVariant => _selectedProductVariant.value;
  set selectedProductVariant(ProductVariant? value) =>
      _selectedProductVariant.value = value ?? ProductVariant();

  final String code;
  final String productCode;
  RxDouble? selectedUnitPrice = 0.0.obs;
  RxBool isColorEnabled = true.obs;
  RxInt selectedSize = (-1).obs;
  RxInt selectedColor = (-1).obs;
  String? selectedSizeName = '';
  String? selectedColorName = '';

  final TextEditingController cQty = TextEditingController(text: '0');

  final Rx<CartProductModel> _cartProduct = Rx(
    CartProductModel(
        id: 0,
        code: '',
        name: '',
        price: 0,
        quantity: 0,
        pictureUrl: baseLogoUrl,),
  );
  CartProductModel get cartProduct => _cartProduct.value;
  set cartProduct(CartProductModel value) => _cartProduct.value = value;

  @override
  Future<void> onReady() async {
    super.onReady();
    await onReadyGeneric(() async {
      await _getProductDetail();
    });
  }

  Future<void> _getProductDetail() async {
    await client.appService.productDetail(code).handleRequest(
      onSuccess: (res) {
        product = res!;
        selectedColorName = product.colors?.first;
        selectedSizeName = product.sizes?.first;
      },
    );
  }

  void onTapColor(int index) {
    selectedColor.value = index;
    selectedColorName = product.colors?[index];
    selectedSizeName = null;
    selectedSize.value = -1;
    selectProduct(selectedColorName, selectedSizeName);
    update();
  }

  void onTapSize(int index) {
    selectedSize.value = index;
    selectedSizeName = product.sizes?[index];
    selectProduct(selectedColorName, selectedSizeName);
  }

  void selectProduct(String? colorName, String? sizeName) {
    selectedProductVariant = product.productVariants!
        .where(
          (element) =>
              element.colorName == colorName && element.sizeName == sizeName,
        )
        .firstOrNull;
    selectedUnitPrice?.value = selectedProductVariant?.unitPrice ?? 0.0;
    if(selectedProductVariant?.productCode==null) return;
    fillCartModel();
  }

  void fillCartModel() {
    cartProduct = CartProductModel(
      id: selectedProductVariant?.productId ?? 0,
      code: selectedProductVariant!.productCode!,
      name: selectedProductVariant?.productName,
      price: selectedUnitPrice?.value ?? 0,
      quantity: int.parse(cQty.text),
      pictureUrl: product.pictureUrl ?? baseLogoUrl,
    );
  }

  RxBool sizeEnableCheck(int index) {
    if (product.productVariants!.any(
      (element) =>
          element.colorName == selectedColorName &&
          element.sizeName == product.sizes?[index],
    )) return true.obs;

    return false.obs;
  }
}
