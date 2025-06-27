import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:kota_app/product/managers/cart_controller.dart';
import 'package:kota_app/product/models/cart_product_model.dart';

void main() {
  group('Cart Performance Tests', () {
    late CartController cartController;

    setUpAll(() {
      // Initialize Flutter test bindings
      TestWidgetsFlutterBinding.ensureInitialized();
    });

    setUp(() {
      // Initialize GetX
      Get.testMode = true;

      // Mock SharedPreferences for testing
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/shared_preferences'),
        (MethodCall methodCall) async {
          if (methodCall.method == 'getAll') {
            return <String, dynamic>{};
          }
          return null;
        },
      );

      cartController = CartController();
    });

    tearDown(() {
      // Clear mock handlers
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/shared_preferences'),
        null,
      );
      Get.reset();
    });

    test('should handle large cart with pagination', () async {
      // Generate 500 test items
      final testItems = _generateTestItems(500);
      
      // Add items to cart
      for (final item in testItems) {
        cartController.onTapAddProduct(item);
      }
      
      // Verify total items
      expect(cartController.itemList.length, equals(500));
      
      // Verify pagination is working
      expect(cartController.displayedItems.length, lessThanOrEqualTo(50));
      expect(cartController.hasMoreItems, isTrue);
      expect(cartController.currentPage, equals(0));
    });

    test('should load more items when requested', () async {
      // Generate 100 test items
      final testItems = _generateTestItems(100);
      
      // Add items to cart
      for (final item in testItems) {
        cartController.onTapAddProduct(item);
      }
      
      // Initial state
      final initialDisplayedCount = cartController.displayedItems.length;
      expect(initialDisplayedCount, equals(50));
      expect(cartController.hasMoreItems, isTrue);
      
      // Load more items
      await cartController.loadMoreItems();
      
      // Verify more items are loaded
      expect(cartController.displayedItems.length, equals(100));
      expect(cartController.hasMoreItems, isFalse);
      expect(cartController.currentPage, equals(1));
    });

    test('should reset pagination when cart is cleared', () async {
      // Generate test items
      final testItems = _generateTestItems(100);
      
      // Add items to cart
      for (final item in testItems) {
        cartController.onTapAddProduct(item);
      }
      
      // Load more items
      await cartController.loadMoreItems();
      
      // Verify state before clearing
      expect(cartController.itemList.length, equals(100));
      expect(cartController.displayedItems.length, equals(100));
      expect(cartController.currentPage, equals(1));
      
      // Clear cart
      await cartController.clearCart();
      
      // Verify pagination is reset
      expect(cartController.itemList.length, equals(0));
      expect(cartController.displayedItems.length, equals(0));
      expect(cartController.currentPage, equals(0));
      expect(cartController.hasMoreItems, isFalse);
    });

    test('should handle adding and removing items with pagination', () async {
      // Generate test items
      final testItems = _generateTestItems(75);
      
      // Add items to cart
      for (final item in testItems) {
        cartController.onTapAddProduct(item);
      }
      
      // Verify initial state
      expect(cartController.itemList.length, equals(75));
      expect(cartController.displayedItems.length, equals(50));
      expect(cartController.hasMoreItems, isTrue);
      
      // Remove an item
      cartController.onTapRemoveProduct(testItems.first);
      
      // Verify pagination is updated
      expect(cartController.itemList.length, equals(74));
      expect(cartController.displayedItems.length, equals(50));
      expect(cartController.hasMoreItems, isTrue);
      
      // Add a new item
      final newItem = _generateTestItems(1).first;
      cartController.onTapAddProduct(newItem);
      
      // Verify pagination is updated
      expect(cartController.itemList.length, equals(75));
      expect(cartController.displayedItems.length, equals(50));
      expect(cartController.hasMoreItems, isTrue);
    });

    test('should not load more items when already loading', () async {
      // Generate test items
      final testItems = _generateTestItems(100);
      
      // Add items to cart
      for (final item in testItems) {
        cartController.onTapAddProduct(item);
      }
      
      // Start loading more items (don't await)
      final future1 = cartController.loadMoreItems();
      
      // Try to load more items again immediately
      final future2 = cartController.loadMoreItems();
      
      // Wait for both to complete
      await Future.wait([future1, future2]);
      
      // Verify items are loaded only once
      expect(cartController.displayedItems.length, equals(100));
      expect(cartController.currentPage, equals(1));
    });

    test('should handle edge case with exactly page size items', () async {
      // Generate exactly 50 items (one page)
      final testItems = _generateTestItems(50);
      
      // Add items to cart
      for (final item in testItems) {
        cartController.onTapAddProduct(item);
      }
      
      // Verify pagination state
      expect(cartController.itemList.length, equals(50));
      expect(cartController.displayedItems.length, equals(50));
      expect(cartController.hasMoreItems, isFalse);
      expect(cartController.currentPage, equals(0));
    });
  });
}

/// Helper function to generate test cart items
List<CartProductModel> _generateTestItems(int count) {
  final items = <CartProductModel>[];
  
  for (int i = 1; i <= count; i++) {
    items.add(CartProductModel(
      id: i,
      code: 'TEST$i',
      name: 'Test Product $i',
      price: 100.0 + i,
      quantity: 1,
      pictureUrl: 'https://example.com/image$i.jpg',
    ));
  }
  
  return items;
}
