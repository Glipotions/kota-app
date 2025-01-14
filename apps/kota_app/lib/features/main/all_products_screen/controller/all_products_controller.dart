import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:go_router/go_router.dart';
import 'package:kota_app/product/base/controller/base_controller.dart';
import 'package:kota_app/product/navigation/modules/sub_route/sub_route_enums.dart';

class AllProductsController extends BaseControllerInterface {
  ProductGroupListResponseModel productsResponse =
      ProductGroupListResponseModel();

  final ScrollController scrollController = ScrollController();

  final Rx<List<ProductGroupItem>> _products = Rx([]);
  final Rx<List<ProductGroupItem>> _filteredProducts = Rx([]);
  final Rx<bool> _isPaginationLoading = Rx(false);
  final Rx<bool> _isInSearchMode = Rx(false);

  bool get isPaginationLoading => _isPaginationLoading.value;
  set isPaginationLoading(bool value) => _isPaginationLoading.value = value;

  bool get isInSearchMode => _isInSearchMode.value;
  set isInSearchMode(bool value) => _isInSearchMode.value = value;

  List<ProductGroupItem> get products => _products.value;
  set products(List<ProductGroupItem> value) => _products
    ..firstRebuild = true
    ..value = value;

  List<ProductGroupItem> get filteredProducts => _filteredProducts.value;
  set filteredProducts(List<ProductGroupItem> value) => _filteredProducts
    ..firstRebuild = true
    ..value = value;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(onLazyLoad);
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    await onReadyGeneric(() async {
      await _getProducts();
    });
  }

  @override
  void onClose() {
    super.onClose();
    scrollController.dispose();
  }

  Future<void> _getProducts() async {
    final request = ProductGroupListRequestModel(
      pageIndex:
          productsResponse.index == null ? 0 : productsResponse.index! + 1,
      pageSize: 25,
    );

    await client.appService.allProducts(request: request).handleRequest(
      onSuccess: (res) {
        productsResponse = res!;
        if (res.items != null) {
          products.addAll(res.items!);
          products = products;
        }
      },
    );
  }

  Future<List<ProductGroupItem>> getSearchProducts(String searchText) async {
    final request = ProductGroupListRequestModel(
      pageIndex: 0,
      pageSize: 10,
      searchText: searchText,
    );

    await client.appService.allProducts(request: request).handleRequest(
      onSuccess: (res) {
        filteredProducts = <ProductGroupItem>[];
        productsResponse = res!;
        if (res.items != null) {
          filteredProducts.addAll(res.items!);
        }
        filteredProducts = filteredProducts;
      },
    );
    return filteredProducts;
  }

  Future<void> getByBarcode(String barcode) async {
    ProductGroupItem? productGroupItem;
    await client.appService.productByBarcode(barcode).handleRequest(
      onSuccess: (res) {
        productGroupItem = res;
      },
    );

    if (productGroupItem != null) {
      await context.pushNamed(
        SubRouteEnums.productDetail.name,
        pathParameters: {
          'id': productGroupItem!.code!,
          'productCode': productGroupItem!.name!,
        },
      );
    }
  }

  Future<void> onLazyLoad() async {
    if (!isInSearchMode &&
        !isPaginationLoading &&
        scrollController.offset >= scrollController.position.maxScrollExtent &&
        !scrollController.position.outOfRange &&
        (productsResponse.hasNext ?? false)) {
      isPaginationLoading = true;
      await _getProducts();
      isPaginationLoading = false;
    }
  }

  void onTapProductDetail(String code, String? productCode) =>
      context.pushNamed(
        SubRouteEnums.productDetail.name,
        pathParameters: {'id': code, 'productCode': productCode!},
      );

  void setSearchMode(bool isInSearch) {
    isInSearchMode = isInSearch;
    if (!isInSearch) {
      productsResponse = ProductGroupListResponseModel();
      _products.value.clear();
      if (scrollController.hasClients) {
        scrollController.jumpTo(0);
      }
      _getProducts();
    }
  }
}
