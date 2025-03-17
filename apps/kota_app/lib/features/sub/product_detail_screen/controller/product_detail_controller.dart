import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota_app/product/base/controller/base_controller.dart';
import 'package:kota_app/product/consts/general.dart';
import 'package:kota_app/product/managers/cart_controller.dart';
import 'package:kota_app/product/models/cart_product_model.dart';

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
  RxInt productCountInPackage = 1.obs;
  RxDouble? selectedUnitPrice = 0.0.obs;
  RxDouble? selectedCurrencyUnitPrice = 0.0.obs;
  RxDouble? showUnitPrice = 0.0.obs;
  RxBool isColorEnabled = true.obs;
  RxInt selectedSize = (-1).obs;
  RxInt selectedColor = (-1).obs;
  String? selectedSizeName = '';
  String? selectedColorName = '';

  TextEditingController cQty = TextEditingController(text: '0');

  final Rx<CartProductModel> _cartProduct = Rx(
    CartProductModel(
      id: 0,
      code: '',
      name: '',
      price: 0,
      quantity: 0,
      pictureUrl: baseLogoUrl,
    ),
  );
  CartProductModel get cartProduct => _cartProduct.value;
  set cartProduct(CartProductModel value) => _cartProduct.value = value;

  @override
  Future<void> onReady() async {
    super.onReady();
    cQty.text = '0';
    await onReadyGeneric(() async {
      await _getProductDetail();
    });
  }

  Future<void> _getProductDetail() async {
    await client.appService
        .productDetail(code, sessionHandler.currentUser?.currencyType ?? 1)
        .handleRequest(
      onSuccess: (res) {
        if (res != null) {
          product = res;

          // Önce renk seçimi yap
          if (product.colors?.isNotEmpty ?? false) {
            selectedColorName = product.colors?.first;
            selectedColor.value = 0;
          }

          // Bedenleri sırala ve ilk bedeni seç
          if (product.sizes?.isNotEmpty ?? false) {
            final sortedSizes = product.sizes!.sortSizes();
            selectedSizeName = sortedSizes.first;
            // UI'daki sıralamaya göre index bul
            selectedSize.value = product.sizes!.indexOf(sortedSizes.first);
          }
          selectProduct(selectedColorName, selectedSizeName);
          update();
        }
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
    cartProduct = cartProduct.copyWith(id: 0);
  }

  void onTapSize(int index) {
    selectedSize.value = index;
    selectedSizeName = product.sizes?[index];
    selectProduct(selectedColorName, selectedSizeName);
    update();
  }

  void selectProduct(String? colorName, String? sizeName) {
    selectedProductVariant = product.productVariants!
        .where(
          (element) =>
              element.colorName == colorName && element.sizeName == sizeName,
        )
        .firstOrNull;
    selectedUnitPrice?.value = selectedProductVariant?.unitPrice ?? 0.0;
    selectedCurrencyUnitPrice?.value =
        selectedProductVariant?.currencyUnitPrice ?? 0.0;

    showUnitPrice?.value = selectedProductVariant?.currencyUnitPrice != 0.0 &&
            selectedProductVariant?.currencyUnitPrice != null
        ? selectedProductVariant!.currencyUnitPrice!
        : selectedProductVariant?.unitPrice ?? 0.0;

    // Check if product exists in cart
    final cartController = Get.find<CartController>();
    final cartItem = cartController.itemList.firstWhereOrNull((item) =>
        item.code == selectedProductVariant?.productCode &&
        item.colorName == selectedProductVariant?.colorName &&
        item.sizeName == selectedProductVariant?.sizeName);

    // Set quantity from cart if exists, otherwise use product count in package
    cQty.text = cartItem != null
        ? cartItem.quantity.toString()
        : (selectedProductVariant?.productCountInPackage ?? 0).toString();

    if (selectedProductVariant?.productCode == null) return;
    fillCartModel();
    update();
  }

  void fillCartModel() {
    cartProduct = CartProductModel(
      id: selectedProductVariant?.productId ?? 0,
      code: selectedProductVariant!.productCode!,
      name: selectedProductVariant?.productName,
      price: selectedUnitPrice?.value ?? 0,
      currencyUnitPrice: selectedCurrencyUnitPrice?.value ?? 0,
      quantity: int.parse(cQty.text == '' ? '0' : cQty.text),
      pictureUrl: product.pictureUrl ?? baseLogoUrl,
      sizeName: selectedProductVariant!.sizeName,
      colorName: selectedProductVariant!.colorName,
      productCodeGroupId: selectedProductVariant!.productCodeGroupId,
    );
  }

  String getSelectedColorImageUrl() {
    if (selectedColorName == null) return product.pictureUrl ?? '';

    // Get first product variant with selected color
    final colorVariant = product.productVariants?.firstWhereOrNull(
      (variant) => variant.colorName == selectedColorName,
    );

    // Return variant picture if exists, otherwise fall back to general picture
    return colorVariant?.pictureUrl?.isNotEmpty == true
        ? colorVariant!.pictureUrl!
        : product.pictureUrl ?? '';
  }

  String getSelectedProductImageUrl() {
    // If no color or size is selected, return default product image
    if (selectedColorName == null && selectedSizeName == null) {
      return product.pictureUrl ?? '';
    }

    // Try to get variant with both selected color and size
    if (selectedColorName != null && selectedSizeName != null) {
      final variant = product.productVariants?.firstWhereOrNull(
        (variant) => 
            variant.colorName == selectedColorName && 
            variant.sizeName == selectedSizeName,
      );

      if (variant?.pictureUrl?.isNotEmpty == true) {
        return variant!.pictureUrl!;
      }
    }

    // Fall back to color-based image if specific variant not found
    return getSelectedColorImageUrl();
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
      'hardal': const Color(0xFFDBB800),
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
