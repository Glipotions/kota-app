// ignore_for_file: omit_local_variable_types

import 'dart:convert';

import 'package:api/api.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:go_router/go_router.dart';
import 'package:kota_app/features/sub/current_account_screen/view/current_account.dart';
import 'package:kota_app/product/base/controller/base_controller.dart';
import 'package:kota_app/product/consts/claims.dart';
import 'package:kota_app/product/managers/session_handler.dart';
import 'package:kota_app/product/models/cart_product_model.dart';
import 'package:kota_app/product/navigation/modules/sub_route/sub_route_enums.dart';
import 'package:kota_app/product/utility/enums/cache_enums.dart';
import 'package:kota_app/product/utility/enums/currency_type.dart';
import 'package:kota_app/product/utility/enums/general.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:widgets/widget.dart';

class CartController extends BaseControllerInterface {
  static const String _cartKey = 'cart_items';
  final Rx<List<CartProductModel>> _itemList = Rx([]);
  final RxBool isDescriptionVisible = false.obs;
  final TextEditingController descriptionController = TextEditingController();
  RxInt? editingOrderId = RxInt(0);

  // Currency related cached values
  late final Rx<int> _currencyType = 1.obs;
  late final Rx<bool> _isCurrencyTL = true.obs;

  // Discount rate for the entire cart (0-100%)
  final RxDouble cartDiscountRate = RxDouble(0);
  final TextEditingController discountController =
      TextEditingController(text: '0');
  final FocusNode discountFocusNode = FocusNode();

  // Performance optimization properties
  static const int _itemsPerPage = 50;
  final RxInt _currentPage = 0.obs;
  final RxBool _isLoadingMore = false.obs;
  final RxBool _hasMoreItems = true.obs;
  final Rx<List<CartProductModel>> _displayedItems = Rx([]);

  // Getters for performance properties
  int get currentPage => _currentPage.value;
  bool get isLoadingMore => _isLoadingMore.value;
  bool get hasMoreItems => _hasMoreItems.value;
  List<CartProductModel> get displayedItems => _displayedItems.value;

  // Check if user has admin rights
  bool get hasAdminRights =>
      SessionHandler.instance.hasClaim(saleInvoiceAdminClaim);

  List<CartProductModel> get itemList => _itemList.value;
  set itemList(List<CartProductModel> value) => _itemList
    ..firstRebuild = true
    ..value = value;

  int get currencyType => _currencyType.value;
  bool get isCurrencyTL => _isCurrencyTL.value;

  void updateCurrencyValues() {
    _currencyType.value = sessionHandler.currentUser?.currencyType ?? 1;
    _isCurrencyTL.value =
        CurrencyType.tl == CurrencyType.fromValue(_currencyType.value);
  }

  @override
  Future<void> onReady() async {
    super.onReady();
    await onReadyGeneric(() async {
      updateCurrencyValues();
      await loadCartItems();
      _setupDiscountFocusListener();
    });
  }

  /// Setup focus listener for discount field to format on focus loss
  void _setupDiscountFocusListener() {
    discountFocusNode.addListener(() {
      if (!discountFocusNode.hasFocus) {
        // Format the discount rate when focus is lost
        formatDiscountRate();
      }
    });
  }

  Future<void> loadCartItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String? cartJson = prefs.getString(_cartKey);
      if (cartJson != null) {
        final List<dynamic> decodedList =
            json.decode(cartJson) as List<dynamic>;
        itemList = decodedList
            .map(
              (item) => CartProductModel.fromJson(item as Map<String, dynamic>),
            )
            .toList();

        // Initialize pagination after loading items
        _initializePagination();
      }

      // Load discount data after loading cart items
      await _loadDiscountData();
    } catch (e) {
      debugPrint('Error loading cart items: $e');
    }
  }

  /// Initialize pagination for cart items
  void _initializePagination() {
    _currentPage.value = 0;
    _hasMoreItems.value = itemList.length > _itemsPerPage;
    _loadDisplayedItems();
  }

  /// Load items for current page
  void _loadDisplayedItems() {
    final startIndex = 0;
    final endIndex = (_currentPage.value + 1) * _itemsPerPage;
    final actualEndIndex = endIndex > itemList.length ? itemList.length : endIndex;

    _displayedItems.value = itemList.sublist(startIndex, actualEndIndex);
    _hasMoreItems.value = actualEndIndex < itemList.length;
  }

  /// Load more items when scrolling
  Future<void> loadMoreItems() async {
    if (_isLoadingMore.value || !_hasMoreItems.value) return;

    _isLoadingMore.value = true;

    // Simulate loading delay for better UX
    await Future.delayed(const Duration(milliseconds: 300));

    _currentPage.value++;
    _loadDisplayedItems();

    _isLoadingMore.value = false;
  }

  /// Reset pagination when cart changes
  void _resetPagination() {
    _currentPage.value = 0;
    _initializePagination();
  }

  Future<void> _saveCartItems() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final String cartJson =
          json.encode(itemList.map((item) => item.toJson()).toList());
      await prefs.setString(_cartKey, cartJson);

      // Also save discount data when saving cart items
      await _saveDiscountData();
    } catch (e) {
      debugPrint('Error saving cart items: $e');
    }
  }

  /// Save discount data to local storage with user-specific keys
  Future<void> _saveDiscountData() async {
    try {
      // Only save discount data if user is logged in
      if (sessionHandler.userAuthStatus != UserAuthStatus.authorized ||
          sessionHandler.currentUser?.id == null) {
        return;
      }

      final userId = sessionHandler.currentUser!.id!;
      final discountRateKey = '${CacheKey.cartDiscountRate.name}_$userId';
      final descriptionKey = '${CacheKey.cartDescription.name}_$userId';

      await LocaleManager.instance.setStringValue(
        key: discountRateKey,
        value: cartDiscountRate.value.toString(),
      );

      await LocaleManager.instance.setStringValue(
        key: descriptionKey,
        value: descriptionController.text,
      );
    } catch (e) {
      debugPrint('Error saving discount data: $e');
    }
  }

  /// Load discount data from local storage with user-specific keys
  Future<void> _loadDiscountData() async {
    try {
      // Only load discount data if user is logged in
      if (sessionHandler.userAuthStatus != UserAuthStatus.authorized ||
          sessionHandler.currentUser?.id == null) {
        return;
      }

      final userId = sessionHandler.currentUser!.id!;
      final discountRateKey = '${CacheKey.cartDiscountRate.name}_$userId';
      final descriptionKey = '${CacheKey.cartDescription.name}_$userId';

      final savedDiscountRate = LocaleManager.instance.getStringValue(key: discountRateKey);
      final savedDescription = LocaleManager.instance.getStringValue(key: descriptionKey);

      if (savedDiscountRate != null) {
        final discountValue = double.tryParse(savedDiscountRate) ?? 0.0;
        if (discountValue >= 0 && discountValue <= 100) {
          cartDiscountRate.value = discountValue;
          discountController.text = discountValue.toString();
        }
      }

      if (savedDescription != null) {
        descriptionController.text = savedDescription;
      }
    } catch (e) {
      debugPrint('Error loading discount data: $e');
    }
  }

  Future<void> clearCart() async {
    editingOrderId?.value = 0;
    itemList = [];
    _displayedItems.value = [];
    _currentPage.value = 0;
    _hasMoreItems.value = false;
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_cartKey);
    descriptionController.text = '';
    discountController.text = '0';
    cartDiscountRate.value = 0;

    // Clear discount data from storage
    await _clearDiscountData();
  }

  /// Clear discount data from local storage for the current user
  Future<void> _clearDiscountData() async {
    try {
      // Only clear discount data if user is logged in
      if (sessionHandler.userAuthStatus != UserAuthStatus.authorized ||
          sessionHandler.currentUser?.id == null) {
        return;
      }

      final userId = sessionHandler.currentUser!.id!;
      final discountRateKey = '${CacheKey.cartDiscountRate.name}_$userId';
      final descriptionKey = '${CacheKey.cartDescription.name}_$userId';

      await LocaleManager.instance.removeAt(discountRateKey);
      await LocaleManager.instance.removeAt(descriptionKey);
    } catch (e) {
      debugPrint('Error clearing discount data: $e');
    }
  }

  /// Save description data when it changes
  void onDescriptionChanged() {
    _saveDiscountData();
  }

  /// Clear discount data for a specific user (used during logout)
  static Future<void> clearDiscountDataForUser(int userId) async {
    try {
      final discountRateKey = '${CacheKey.cartDiscountRate.name}_$userId';
      final descriptionKey = '${CacheKey.cartDescription.name}_$userId';

      await LocaleManager.instance.removeAt(discountRateKey);
      await LocaleManager.instance.removeAt(descriptionKey);
    } catch (e) {
      debugPrint('Error clearing discount data for user $userId: $e');
    }
  }

  void onTapAddProduct(CartProductModel item) {
    // updateCurrencyValues();
    if (item.quantity == 0) {
      onTapRemoveProduct(item);
      return;
    }
    if (itemList.indexWhere((element) => element.id == item.id) != -1) {
      itemList.removeWhere((element) => element.id == item.id);
    }
    itemList.add(item);
    itemList = itemList;
    _saveCartItems();
    _initializePagination(); // Refresh pagination after adding item
  }

  void onTapRemoveProduct(CartProductModel item) {
    if (itemList.indexWhere((element) => element.id == item.id) != -1) {
      itemList.removeWhere((element) => element.id == item.id);
    }
    itemList = itemList;
    _saveCartItems();
    _initializePagination(); // Refresh pagination after removing item
  }

  CartProductModel? inChartItemById(int id) =>
      itemList.firstWhereOrNull((element) => element.id == id);

  /// Navigate to product detail screen from cart item
  void onTapProductDetail(CartProductModel item) {
    // Use mainProductCode if available, otherwise fall back to code
    final productCodeGroupId = item.productCodeGroupId;

    if (productCodeGroupId != null &&
        item.name != null &&
        item.name!.isNotEmpty) {
      context.pushNamed(
        SubRouteEnums.productDetail.name,
        pathParameters: {
          'id': item.mainProductCode!,
          'productCode': item.code,
        },
      );
    }
  }

  double totalAmount({bool withDiscount = true}) {
    double totalAmount = 0;
    double totalCurrencyAmount = 0;

    for (final element in itemList) {
      totalAmount = totalAmount + (element.price * element.quantity);
      if (element.currencyUnitPrice != null) {
        totalCurrencyAmount = totalCurrencyAmount +
            (element.currencyUnitPrice! * element.quantity);
      }
    }

    final baseAmount = isCurrencyTL ? totalAmount : totalCurrencyAmount;

    // Apply discount if requested
    if (withDiscount && cartDiscountRate.value > 0) {
      final discountAmount = baseAmount * (cartDiscountRate.value / 100);
      return baseAmount - discountAmount;
    }

    return baseAmount;
  }

  // Calculate the discount amount
  double discountAmount() {
    final baseAmount = totalAmount(withDiscount: false);
    return baseAmount * (cartDiscountRate.value / 100);
  }

  // Update discount rate from the text field
  void updateDiscountRate(String value) {
    try {
      // Allow empty input or just decimal separators during typing
      if (value.isEmpty || value == '.' || value == ',') {
        cartDiscountRate.value = 0;

        // Apply zero discount rate to all items in the cart
        for (final item in itemList) {
          item.discountRate = 0;
        }

        // Update the cart items to trigger UI refresh
        itemList = List<CartProductModel>.from(itemList);
        _saveCartItems();
        return;
      }

      // Replace comma with dot for parsing
      final normalizedValue = value.replaceAll(',', '.');
      final newRate = double.parse(normalizedValue);

      if (newRate >= 0 && newRate <= 100) {
        cartDiscountRate.value = newRate;

        // Apply the discount rate to all items in the cart
        for (final item in itemList) {
          item.discountRate = newRate;
        }

        // Update the cart items to trigger UI refresh
        itemList = List<CartProductModel>.from(itemList);
        _saveCartItems();
      }
    } catch (e) {
      debugPrint('Error parsing discount rate: $e');
    }
  }

  // Format discount rate when user finishes editing (called on focus loss)
  void formatDiscountRate() {
    try {
      final currentText = discountController.text.trim();

      // Handle empty input
      if (currentText.isEmpty) {
        discountController.text = '0';
        cartDiscountRate.value = 0;
        return;
      }

      // Replace comma with dot for parsing
      final normalizedValue = currentText.replaceAll(',', '.');
      final rate = double.parse(normalizedValue);

      if (rate >= 0 && rate <= 100) {
        // Format the number properly - remove unnecessary decimal places
        final formattedRate = rate == rate.toInt() ? rate.toInt().toString() : rate.toString();

        // Only update if the formatted value is different from current text
        if (discountController.text != formattedRate) {
          discountController.text = formattedRate;
        }

        cartDiscountRate.value = rate;
      } else {
        // Reset to valid range
        final clampedRate = rate.clamp(0.0, 100.0);
        final formattedRate = clampedRate == clampedRate.toInt() ? clampedRate.toInt().toString() : clampedRate.toString();
        discountController.text = formattedRate;
        cartDiscountRate.value = clampedRate;
      }
    } catch (e) {
      debugPrint('Error formatting discount rate: $e');
      // Reset to 0 on error
      discountController.text = '0';
      cartDiscountRate.value = 0;
    }
  }

  Future<void> completeOrder(BuildContext context) async {
    if (itemList.isEmpty) {
      showErrorToastMessage('Sepetiniz boş');
      return;
    }

    if (sessionHandler.currentUser == null) {
      await context.pushNamed(SubRouteEnums.loginSubScreen.name);
      return;
    }

    // Admin yetkisi varsa cari hesap seçme ekranını göster
    if (SessionHandler.instance.hasClaim(saleInvoiceAdminClaim)) {
      final result = await Navigator.push<GetCurrentAccount>(
        context,
        MaterialPageRoute(
          builder: (context) => const CurrentAccount(
            pageStatusEnum: ScreenArgumentEnum.SelectToBack,
          ),
        ),
      );

      if (result == null) return;

      // Onay dialogu göster
      final confirmed = await showDialog<bool>(
        context: context,
        barrierDismissible: false,
        builder: (context) {
          final labels = AppLocalization.getLabels(context);
          return AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(16),
            ),
            backgroundColor: Theme.of(context).cardColor,
            title: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    Icons.shopping_cart_checkout,
                    size: 48,
                    color: Theme.of(context).colorScheme.primary,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  labels.orderConfirmationTitle,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.onSurface,
                      ),
                ),
              ],
            ),
            content: Text(
              labels.orderConfirmationMessage(result.firma!),
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
            ),
            actionsAlignment: MainAxisAlignment.spaceEvenly,
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                style: TextButton.styleFrom(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  labels.cancel,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Theme.of(context).colorScheme.primary,
                  padding:
                      const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  labels.confirm,
                  style: Theme.of(context).textTheme.labelLarge?.copyWith(
                        color: Theme.of(context).colorScheme.onPrimary,
                      ),
                ),
              ),
            ],
          );
        },
      );

      if (confirmed != true) return;

      await _completeOrder(result.id.toString(), context);
    } else {
      await _completeOrder(
        sessionHandler.currentUser!.currentAccountId!.toString(),
        context,
      );
    }
  }

  Future<void> _completeOrder(String cariHesapId, BuildContext context) async {
    // Dismiss keyboard before proceeding
    FocusScope.of(context).unfocus();

    final labels = AppLocalization.getLabels(context);

    // Check if order is too large and needs batching
    const maxItemsPerOrder = 500;
    if (itemList.length > maxItemsPerOrder) {
      await _handleLargeOrder(cariHesapId, context, maxItemsPerOrder);
      return;
    }

    LoadingProgress.start();
    try {
      // Send original prices and discount rate to the backend for server-side calculation
      final request = CreateOrderRequestModel(
        id: editingOrderId?.value,
        cariHesapId: cariHesapId,
        connectedBranchCurrentInfoId:
            SessionHandler.instance.currentUser!.connectedBranchCurrentInfoId,
        description: _buildDescriptionWithDiscount(),
        generalDiscountRate:
            cartDiscountRate.value > 0 ? cartDiscountRate.value : null,
        orderDetails: itemList
            .map(
              (e) => OrderDetail(
                id: e.orderDetailId ?? 0,
                amount: e.quantity.toString(),
                productId: e.id.toString(),
                // Send original prices (without discount applied)
                unitPrice: e.price.toString(),
                currencyUnitPrice: e.currencyUnitPrice?.toString(),
                // Send discount rate for item-level discounts (currently using general discount)
                discountRate: e.discountRate > 0 ? e.discountRate : null,
              ),
            )
            .toList(),
        currencyType: currencyType,
      );

      if (editingOrderId?.value != 0) {
        // Sipariş güncelleme
        await client.appService.updateOrder(request: request).handleRequest(
              onSuccess: (res) async {
                await clearCart();
                showSuccessToastMessage(labels.orderUpdatedSuccessfully);
                // context.pop();
              },
              onIgnoreException: (error) {
                _handleOrderError(error, labels.orderUpdateError, context);
              },
              ignoreException: true,
              defaultResponse: CreateOrderResponseModel(),
            );
      } else {
        // Yeni sipariş oluşturma
        await client.appService.createOrder(request: request).handleRequest(
              onSuccess: (res) async {
                await clearCart();
                showSuccessToastMessage(labels.orderCreatedSuccessfully);
                // context.pop();
              },
              onIgnoreException: (error) {
                _handleOrderError(error, labels.orderCreateError, context);
              },
              ignoreException: true,
              defaultResponse: CreateOrderResponseModel(),
            );
      }
    } finally {
      LoadingProgress.stop();
    }
  }

  /// Handles large orders by batching them into smaller chunks
  Future<void> _handleLargeOrder(
      String cariHesapId, BuildContext context, int maxItemsPerOrder) async {
    final labels = AppLocalization.getLabels(context);

    // Show confirmation dialog for large orders
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(labels.largeOrderWarningTitle),
          content: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).textTheme.bodyMedium?.color,
                  ),
              children: [
                TextSpan(
                  text: labels.largeOrderWarningContent(
                    itemList.length,
                    (itemList.length / maxItemsPerOrder).ceil(),
                  ),
                ),
                TextSpan(text: '\n\n'),
                TextSpan(text: labels.largeOrderWarningMessage),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(labels.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(labels.confirm),
            ),
          ],
        );
      },
    );

    if (confirmed != true) return;

    LoadingProgress.start();
    try {
      // Split items into chunks
      final chunks = <List<CartProductModel>>[];
      for (var i = 0; i < itemList.length; i += maxItemsPerOrder) {
        final end = (i + maxItemsPerOrder < itemList.length)
            ? i + maxItemsPerOrder
            : itemList.length;
        chunks.add(itemList.sublist(i, end));
      }

      var successCount = 0;
      var failureCount = 0;

      // Process each chunk
      for (var i = 0; i < chunks.length; i++) {
        final chunk = chunks[i];
        final chunkDescription =
            '${_buildDescriptionWithDiscount()} - Bölüm ${i + 1}/${chunks.length}';

        final request = CreateOrderRequestModel(
          cariHesapId: cariHesapId,
          connectedBranchCurrentInfoId:
              SessionHandler.instance.currentUser!.connectedBranchCurrentInfoId,
          description: chunkDescription,
          generalDiscountRate:
              cartDiscountRate.value > 0 ? cartDiscountRate.value : null,
          orderDetails: chunk
              .map(
                (e) => OrderDetail(
                  amount: e.quantity.toString(),
                  productId: e.id.toString(),
                  unitPrice: e.price.toString(),
                  currencyUnitPrice: e.currencyUnitPrice?.toString(),
                  discountRate: e.discountRate > 0 ? e.discountRate : null,
                ),
              )
              .toList(),
          currencyType: currencyType,
        );

        try {
          await client.appService.createOrder(request: request).handleRequest(
                onSuccess: (res) async {
                  successCount++;
                },
                onIgnoreException: (error) {
                  failureCount++;
                },
                ignoreException: true,
                defaultResponse: CreateOrderResponseModel(),
              );
        } catch (e) {
          failureCount++;
        }
      }

      // Show results
      if (successCount > 0) {
        await clearCart();
        if (failureCount == 0) {
          showSuccessToastMessage(
              'Tüm siparişler başarıyla oluşturuldu ($successCount sipariş)');
        } else {
          showSuccessToastMessage(
              '$successCount sipariş oluşturuldu, $failureCount sipariş başarısız oldu');
        }
      } else {
        showErrorToastMessage(
            'Hiçbir sipariş oluşturulamadı. Lütfen tekrar deneyin.');
      }
    } finally {
      LoadingProgress.stop();
    }
  }

  /// Handles order creation errors with specific error messages
  void _handleOrderError(
      dynamic error, String defaultMessage, BuildContext context) {
    String errorMessage = defaultMessage;

    // Check for specific error types
    if (error.toString().contains('timeout') ||
        error.toString().contains('Timeout')) {
      errorMessage =
          'Sipariş oluşturma zaman aşımına uğradı. Sepetinizdeki ürün sayısını azaltıp tekrar deneyin.';
    } else if (error.toString().contains('too large') ||
        error.toString().contains('payload')) {
      errorMessage =
          'Sipariş çok büyük. Lütfen sepetinizdeki ürün sayısını azaltın.';
    } else if (error.toString().contains('network') ||
        error.toString().contains('connection')) {
      errorMessage =
          'Ağ bağlantısı sorunu. Lütfen internet bağlantınızı kontrol edin.';
    } else if (error.toString().contains('server') ||
        error.toString().contains('500')) {
      errorMessage = 'Sunucu hatası. Lütfen daha sonra tekrar deneyin.';
    }

    showErrorToastMessage(errorMessage);
  }

  /// Builds description with discount information, preventing duplication
  String _buildDescriptionWithDiscount() {
    var description = descriptionController.text.trim();

    // Remove any existing discount text to prevent duplication
    final discountPattern = RegExp(r'\s*\(İskonto:?\s*%[\d.,]+\)');
    description = description.replaceAll(discountPattern, '').trim();

    // Add current discount if applicable
    if (cartDiscountRate.value > 0) {
      description +=
          ' (İskonto: %${cartDiscountRate.value.toStringAsFixed(2)})';
    }

    return description;
  }

  @override
  void onClose() {
    descriptionController.dispose();
    discountController.dispose();
    discountFocusNode.dispose();
    super.onClose();
  }
}
