import 'dart:async';

import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter_barcode_scanner/flutter_barcode_scanner.dart';
import 'package:get/get.dart';
import 'package:kota_app/features/main/all_products_screen/controller/all_products_controller.dart';
import 'package:kota_app/product/base/base_view.dart';
import 'package:kota_app/product/utility/enums/module_padding_enums.dart';
import 'package:kota_app/product/widgets/app_bar/general_app_bar.dart';
import 'package:kota_app/product/widgets/card/bordered_image.dart';
import 'package:values/values.dart';

part 'components/product_card.dart';

class AllProducts extends StatelessWidget {
  const AllProducts({required this.controller, super.key});

  final AllProductsController controller;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: controller.scaffoldKey,
      appBar: GeneralAppBar(
        title: 'Ürünler',
        additionalIcon: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            controller.setSearchMode(true);
            showSearch(
              context: context,
              delegate: CustomSearchDelegate(controller),
            ).then((_) => controller.setSearchMode(false));
          },
        ),
        leading: IconButton(
          icon: const Icon(Icons.document_scanner),
          onPressed: () => _scanBarcode(controller),
        ),
      ),
      body: BaseView<AllProductsController>(
        controller: controller,
        child: Padding(
          padding: EdgeInsets.all(ModulePadding.s.value),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Flexible(
                child: OrientationBuilder(
                  builder: (context, orientation) => Obx(
                    () => GridView.builder(
                      controller: controller.scrollController,
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: orientation == Orientation.portrait ? 2 : 4,
                        childAspectRatio: 0.645,
                        crossAxisSpacing: ModulePadding.s.value,
                        mainAxisSpacing: ModulePadding.xxs.value,
                      ),
                      itemBuilder: (context, index) {
                        final item = controller.products[index];
                        return ProductCard(
                          onTap: () => controller.onTapProductDetail(
                            item.code!,
                            item.name,
                          ),
                          item: item,
                        );
                      },
                      itemCount: controller.products.length,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CustomSearchDelegate extends SearchDelegate<ProductGroupItem?> {
  CustomSearchDelegate(this.controller);

  final AllProductsController controller;
  Timer? _debounce;

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          showSuggestions(context);
        },
      ),
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  Widget _buildSearchResults() {
    if (query.isEmpty) {
      return const Center(child: Text('Arama terimi giriniz.'));
    }

    return FutureBuilder<List<ProductGroupItem>>(
      future: controller.getSearchProducts(query),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Bir hata oluştu: ${snapshot.error}'));
        } else if (snapshot.hasData && snapshot.data!.isNotEmpty) {
          return _buildProductList(snapshot.data!);
        } else {
          return const Center(child: Text('Ürün bulunamadı'));
        }
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults();
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    return const Center(child: Text("Arama yapıp tamam'a tıklayınız..."));
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  Widget _buildProductList(List<ProductGroupItem> filteredProducts) {
    return Padding(
      padding: EdgeInsets.all(ModulePadding.s.value),
      child: Column(
        children: [
          Flexible(
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 21 / 32,
                crossAxisSpacing: ModulePadding.s.value,
                mainAxisSpacing: ModulePadding.xxs.value,
              ),
              itemBuilder: (context, index) {
                final item = controller.filteredProducts[index];
                return ProductCard(
                  onTap: () => controller.onTapProductDetail(
                    item.code!,
                    item.name,
                  ),
                  item: item,
                );
              },
              itemCount: filteredProducts.length,
            ),
          ),
        ],
      ),
    );
  }
}

Future<void> _scanBarcode(AllProductsController controller) async {
  try {
    final barcode = await FlutterBarcodeScanner.scanBarcode(
      '#ff6666',
      'İptal',
      true,
      ScanMode.BARCODE,
    );
    if (barcode != '-1') {
      await controller.getByBarcode(barcode);
    }
  } catch (e) {
    // Handle error
  }
}
