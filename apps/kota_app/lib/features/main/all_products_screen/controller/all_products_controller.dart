import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get_rx/get_rx.dart';
import 'package:go_router/go_router.dart';
import 'package:kota_app/product/base/controller/base_controller.dart';
import 'package:kota_app/product/navigation/modules/sub_route/sub_route_enums.dart';
import 'package:kota_app/features/main/all_products_screen/model/product_filter.dart';
import 'package:kota_app/features/main/all_products_screen/model/product_category.dart';

class AllProductsController extends BaseControllerInterface {
  ProductGroupListResponseModel productsResponse =
      ProductGroupListResponseModel();

  final ScrollController scrollController = ScrollController();

  final Rx<List<ProductGroupItem>> _products = Rx([]);
  final Rx<List<ProductGroupItem>> _filteredProducts = Rx([]);
  final Rx<List<ProductCategory>> _categories = Rx([]);
  final Rx<bool> _isPaginationLoading = Rx(false);
  final Rx<bool> _isInSearchMode = Rx(false);
  final Rx<ProductFilter> _currentFilter = Rx(ProductFilter());
  final Rx<bool> _hasMoreItems = Rx(true);
  final Rx<bool> _hasActiveFilters = Rx(false);

  bool get isPaginationLoading => _isPaginationLoading.value;
  set isPaginationLoading(bool value) => _isPaginationLoading.value = value;

  bool get isInSearchMode => _isInSearchMode.value;
  set isInSearchMode(bool value) => _isInSearchMode.value = value;

  bool get hasMoreItems => _hasMoreItems.value;
  set hasMoreItems(bool value) => _hasMoreItems.value = value;

  bool get hasActiveFilters => _hasActiveFilters.value;

  ProductFilter get currentFilter => _currentFilter.value;
  set currentFilter(ProductFilter value) {
    _currentFilter.value = value;
    _hasActiveFilters.value = value.category != null || 
        value.minPrice != null || 
        value.maxPrice != null;
  }

  List<ProductGroupItem> get products => _products.value;
  set products(List<ProductGroupItem> value) {
    print('Setting products: ${value.length}'); // Debug print
    _products.value = value;
  }

  List<ProductGroupItem> get filteredProducts => _filteredProducts.value;
  set filteredProducts(List<ProductGroupItem> value) => _filteredProducts.value = value;

  List<ProductCategory> get categories => _categories.value;
  set categories(List<ProductCategory> value) => _categories.value = value;

  @override
  void onInit() {
    super.onInit();
    scrollController.addListener(onLazyLoad);
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    await onReadyGeneric(() async {
      await _getCategories();
      await _getProducts(isRefresh: true);
    });
  }

  @override
  void onClose() {
    super.onClose();
    scrollController.dispose();
  }

  Future<void> _getCategories() async {
    print('Fetching categories...'); // Debug print
    await client.appService.getCategories(
      request: ProductGroupListRequestModel(),
    ).handleRequest(
      onSuccess: (res) {
        print('Categories API Response success: ${res?.items?.length} items'); // Debug print
        if (res?.items != null) {
          categories = res!.items!
              .map((e) => ProductCategory.fromModel(e))
              .toList();
          print('Processed ${categories.length} categories'); // Debug print
        }
      },
    );
  }

  Future<void> _getProducts({bool isRefresh = false}) async {
    print('Starting to fetch products. isRefresh: $isRefresh, isPaginationLoading: $isPaginationLoading, hasMoreItems: $hasMoreItems'); // Debug print
    print('Current filter category before request: ${currentFilter.category?.id}'); // Debug print

    isPaginationLoading = true;

    final request = ProductGroupListRequestModel(
      pageIndex: isRefresh ? 0 : (productsResponse.index ?? 0) + 1,
      pageSize: 25,
      categoryId: currentFilter.category?.id,
      minPrice: currentFilter.minPrice,
      maxPrice: currentFilter.maxPrice,
      sortBy: _getSortByField(),
      sortDirection: _getSortDirection(),
    );

    print('Request with filter: ${request.toJson()}'); // Debug print

    await client.appService.allProducts(request: request).handleRequest(
      onSuccess: (res) {
        print('API Response success: ${res?.items?.length} items'); // Debug print
        if (res != null) {
          productsResponse = res;
          
          if (isRefresh) {
            products = res.items ?? [];
          } else if (res.items != null) {
            final updatedList = List<ProductGroupItem>.from(products)..addAll(res.items!);
            products = updatedList;
          }
          
          print('Updated products length: ${products.length}'); // Debug print
          hasMoreItems = res.hasNext ?? false;
        }
      },
    );

    isPaginationLoading = false;
  }

  String? _getSortByField() {
    if (currentFilter.sortType == null) return null;
    
    switch (currentFilter.sortType!) {
      case ProductSortType.priceAsc:
      case ProductSortType.priceDesc:
        return 'price';
      case ProductSortType.nameAsc:
      case ProductSortType.nameDesc:
        return 'name';
    }
  }

  String? _getSortDirection() {
    if (currentFilter.sortType == null) return null;
    
    switch (currentFilter.sortType!) {
      case ProductSortType.priceAsc:
      case ProductSortType.nameAsc:
        return 'asc';
      case ProductSortType.priceDesc:
      case ProductSortType.nameDesc:
        return 'desc';
    }
  }

  Future<List<ProductGroupItem>> getSearchProducts(String searchText) async {
    final request = ProductGroupListRequestModel(
      pageIndex: 0,
      pageSize: 25,
      searchText: searchText,
      categoryId: currentFilter.category?.id,
    );

    await client.appService.allProducts(request: request).handleRequest(
      onSuccess: (res) {
        filteredProducts = [];
        productsResponse = res!;
        if (res.items != null) {
          filteredProducts = res.items!;
        }
      },
    );
    return filteredProducts;
  }

  void onLazyLoad() {
    if ((scrollController.position.pixels >=
            scrollController.position.maxScrollExtent - 200) &&
        !isPaginationLoading &&
        hasMoreItems) {
      _getProducts();
    }
  }

  Future<void> applyFilter(ProductFilter filter) async {
    print('Applying filter with category: ${filter.category?.id}'); // Debug print
    currentFilter = filter;
    print('Current filter category after setting: ${currentFilter.category?.id}'); // Debug print
    await _getProducts(isRefresh: true);
  }

  void clearFilters() {
    currentFilter = ProductFilter();
    _getProducts(isRefresh: true);
  }

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

  void onTapProductDetail(String code, String? productCode) =>
      context.pushNamed(
        SubRouteEnums.productDetail.name,
        pathParameters: {'id': code, 'productCode': productCode!},
      );

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
}
