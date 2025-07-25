import 'dart:async';

import 'package:api/api.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota_app/features/main/all_products_screen/controller/all_products_controller.dart';
import 'package:kota_app/features/main/all_products_screen/view/components/filter_bottom_sheet.dart';
import 'package:kota_app/product/base/base_view.dart';
import 'package:kota_app/product/utility/enums/module_padding_enums.dart';
import 'package:kota_app/product/widgets/app_bar/general_app_bar.dart';
import 'package:kota_app/product/widgets/badge/new_product_badge.dart';
import 'package:kota_app/product/widgets/card/bordered_image.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:values/values.dart';

part 'components/product_card.dart';

class AllProducts extends StatelessWidget {
  const AllProducts({required this.controller, super.key});

  final AllProductsController controller;

  @override
  Widget build(BuildContext context) {
    final labels = AppLocalization.getLabels(context);
    return Scaffold(
      key: controller.scaffoldKey,
      appBar: GeneralAppBar(
        title: labels.products,
        additionalIcon: IconButton(
          icon: const Icon(Icons.search),
          onPressed: () {
            controller.setSearchMode(isInSearch: true);
            showSearch(
              context: context,
              delegate: CustomSearchDelegate(controller),
            ).then((_) => controller.setSearchMode(isInSearch: false));
          },
        ),
        leading: Obx(
          () => IconButton(
            icon: const Icon(Icons.document_scanner),
            onPressed: controller.isProcessingBarcode
                ? null
                : () => _scanBarcode(controller, context),
          ),
        ),
      ),
      body: BaseView<AllProductsController>(
        controller: controller,
        child: Padding(
          padding: EdgeInsets.all(ModulePadding.s.value),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                margin: EdgeInsets.only(bottom: ModulePadding.s.value),
                child: SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: [
                      ActionChip(
                        avatar: const Icon(Icons.filter_list, size: 20),
                        label: Text(labels.filter),
                        onPressed: () {
                          showModalBottomSheet(
                            context: context,
                            isScrollControlled: true,
                            builder: (context) => Padding(
                              padding: EdgeInsets.only(
                                bottom:
                                    MediaQuery.of(context).viewInsets.bottom,
                              ),
                              child: FilterBottomSheet(controller: controller),
                            ),
                          );
                        },
                      ),
                      const SizedBox(width: 8),
                      Obx(
                        () => Visibility(
                          visible: controller.hasActiveFilters,
                          child: ActionChip(
                            avatar: const Icon(Icons.clear, size: 20),
                            label: Text(labels.clearFilters),
                            onPressed: controller.clearFilters,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Flexible(
                child: OrientationBuilder(
                  builder: (context, orientation) => Obx(
                    () {
                      final items = controller.products;
                      return GridView.builder(
                        controller: controller.scrollController,
                        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                          crossAxisCount:
                              orientation == Orientation.portrait ? 2 : 4,
                          childAspectRatio: 0.645,
                          crossAxisSpacing: ModulePadding.s.value,
                          mainAxisSpacing: ModulePadding.xxs.value,
                        ),
                        itemBuilder: (context, index) {
                          final item = items[index];
                          return ProductCard(
                            onTap: () => controller.onTapProductDetail(
                              item.code!,
                              item.name,
                            ),
                            item: item,
                          );
                        },
                        itemCount: items.length,
                      );
                    },
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

  Widget _buildSearchResults(BuildContext context) {
    final labels = AppLocalization.getLabels(context);
    if (query.isEmpty) {
      return Center(child: Text(labels.searchTermRequired));
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
          return Center(child: Text(labels.noProductsFound));
        }
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return _buildSearchResults(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    final labels = AppLocalization.getLabels(context);
    return Center(child: Text(labels.searchAndSelect));
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

Future<void> _scanBarcode(AllProductsController controller, BuildContext context) async {
  controller.setProcessingBarcode(isProcessing: true);
  
  try {
    final String? barcodeResult = await Navigator.of(context).push<String>(
      MaterialPageRoute<String>(
        builder: (context) => const BarcodeScannerScreen(),
      ),
    );

    // Check if context is still mounted before proceeding
    if (!context.mounted) return;

    if (barcodeResult != null && barcodeResult.isNotEmpty) {
      await controller.getByBarcode(barcodeResult);
    }
  } catch (e) {
    // Handle error
    controller.logger.e('Error during barcode scanning navigation or processing: $e');
  } finally {
    // Ensure the flag is always reset, even on error or if no barcode is returned
    // Check if context is still mounted before accessing controller
    if (context.mounted) {
      controller.setProcessingBarcode(isProcessing: false);
    }
  }
}

/// A separate screen for barcode scanning to follow Single Responsibility Principle
class BarcodeScannerScreen extends StatefulWidget {
  const BarcodeScannerScreen({super.key});

  @override
  State<BarcodeScannerScreen> createState() => _BarcodeScannerScreenState();
}

class _BarcodeScannerScreenState extends State<BarcodeScannerScreen> {
  late MobileScannerController _scannerController;
  bool _isFlashOn = false;
  bool _isPopping = false; // Flag to prevent multiple pops

  @override
  void initState() {
    super.initState();
    _scannerController = MobileScannerController(
      detectionSpeed: DetectionSpeed.normal,
      facing: CameraFacing.back,
    );
  }

  @override
  void dispose() {
    _scannerController.dispose();
    super.dispose();
  }

  void _toggleFlash() {
    setState(() {
      _isFlashOn = !_isFlashOn;
      _scannerController.toggleTorch();
    });
  }

  void _switchCamera() {
    _scannerController.switchCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Barkod Tara'),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: Icon(_isFlashOn ? Icons.flash_on : Icons.flash_off),
            onPressed: _toggleFlash,
          ),
          IconButton(
            icon: const Icon(Icons.cameraswitch),
            onPressed: _switchCamera,
          ),
        ],
      ),
      body: MobileScanner(
        controller: _scannerController,
        onDetect: (BarcodeCapture capture) {
          // If already popping, do nothing
          if (_isPopping) return;

          final List<Barcode> barcodes = capture.barcodes;
          
          if (barcodes.isNotEmpty) {
            for (final barcode in barcodes) {
              if (barcode.rawValue != null) {
                // Set flag to true immediately before popping
                _isPopping = true; 
                // Return the first valid barcode value and close the scanner
                Navigator.pop(context, barcode.rawValue);
                break;
              }
            }
          }
        },
      ),
    );
  }
}
