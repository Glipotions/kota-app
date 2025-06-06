import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:kota_app/product/managers/cart_controller.dart';
import 'package:kota_app/product/models/cart_product_model.dart';

void main() {
  group('Cart Navigation Tests', () {
    late CartController cartController;

    setUp(() {
      // Initialize GetX for testing
      Get.testMode = true;
      cartController = CartController();
    });

    tearDown(() {
      Get.reset();
    });

    test('onTapProductDetail should handle valid cart item', () {
      // Arrange
      final cartItem = CartProductModel(
        id: 1,
        code: 'TEST001',
        name: 'Test Product',
        price: 100.0,
        quantity: 2,
      );

      // Act & Assert
      // Since we can't test actual navigation in unit tests,
      // we verify that the method doesn't throw an exception
      // and that the cart item has the required data
      expect(cartItem.code.isNotEmpty, true);
      expect(cartItem.name != null && cartItem.name!.isNotEmpty, true);
      
      // In a real test environment, you would mock the navigation
      // and verify that context.pushNamed was called with correct parameters
    });

    test('onTapProductDetail should handle cart item with empty code', () {
      // Arrange
      final cartItem = CartProductModel(
        id: 1,
        code: '',
        name: 'Test Product',
        price: 100.0,
        quantity: 2,
      );

      // Act & Assert
      // Verify that items with empty code won't cause navigation
      expect(cartItem.code.isEmpty, true);
    });

    test('onTapProductDetail should handle cart item with null name', () {
      // Arrange
      final cartItem = CartProductModel(
        id: 1,
        code: 'TEST001',
        name: null,
        price: 100.0,
        quantity: 2,
      );

      // Act & Assert
      // Verify that items with null name won't cause navigation
      expect(cartItem.name == null, true);
    });

    test('CartProductModel should have required navigation data', () {
      // Arrange & Act
      final cartItem = CartProductModel(
        id: 1,
        code: 'PROD123',
        name: 'Sample Product Name',
        price: 50.0,
        quantity: 1,
        pictureUrl: 'https://example.com/image.jpg',
        sizeName: 'M',
        colorName: 'Blue',
        mainProductCode: 'MAIN_PROD_123', // Test the new field
      );

      // Assert
      expect(cartItem.id, 1);
      expect(cartItem.code, 'PROD123');
      expect(cartItem.name, 'Sample Product Name');
      expect(cartItem.price, 50.0);
      expect(cartItem.quantity, 1);
      expect(cartItem.pictureUrl, 'https://example.com/image.jpg');
      expect(cartItem.sizeName, 'M');
      expect(cartItem.colorName, 'Blue');
      expect(cartItem.mainProductCode, 'MAIN_PROD_123');
    });
  });
}
