import 'package:api/api.dart';
import 'package:common/common.dart';
import 'package:flutter/services.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get/get.dart';
import 'package:kota_app/product/managers/cart_controller.dart';
import 'package:kota_app/product/managers/session_handler.dart';
import 'package:kota_app/product/utility/enums/cache_enums.dart';

void main() {
  group('Cart Discount Persistence Tests', () {
    late CartController cartController;
    late SessionHandler sessionHandler;
    Map<String, dynamic> mockPrefsData = {};

    setUpAll(() async {
      // Initialize Flutter test bindings
      TestWidgetsFlutterBinding.ensureInitialized();

      // Mock SharedPreferences for LocaleManager initialization
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/shared_preferences'),
        (MethodCall methodCall) async {
          switch (methodCall.method) {
            case 'getAll':
              return <String, dynamic>{};
            case 'setString':
              return true;
            case 'getString':
              return null;
            case 'remove':
              return true;
            case 'clear':
              return true;
            default:
              return null;
          }
        },
      );

      // Initialize LocaleManager once for all tests
      await LocaleManager.cacheInit();
    });

    setUp(() async {
      // Reset GetX
      Get.reset();
      Get.testMode = true;

      // Clear mock data
      mockPrefsData.clear();

      // Mock SharedPreferences for testing
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('plugins.flutter.io/shared_preferences'),
        (MethodCall methodCall) async {
          switch (methodCall.method) {
            case 'getAll':
              return mockPrefsData;
            case 'setString':
              final key = methodCall.arguments['key'] as String;
              final value = methodCall.arguments['value'] as String;
              mockPrefsData[key] = value;
              return true;
            case 'getString':
              final key = methodCall.arguments['key'] as String;
              return mockPrefsData[key];
            case 'remove':
              final key = methodCall.arguments['key'] as String;
              mockPrefsData.remove(key);
              return true;
            case 'clear':
              mockPrefsData.clear();
              return true;
            default:
              return null;
          }
        },
      );

      // Mock FlutterSecureStorage for testing
      TestDefaultBinaryMessengerBinding.instance.defaultBinaryMessenger
          .setMockMethodCallHandler(
        const MethodChannel('plugins.it_nomads.com/flutter_secure_storage'),
        (MethodCall methodCall) async {
          return null;
        },
      );

      // Create mock user for testing
      final mockUser = User(
        id: 123,
        fullName: 'Test User',
        email: 'test@example.com',
        currencyType: 1,
      );

      // Initialize SessionHandler
      sessionHandler = SessionHandler.instance;
      sessionHandler.currentUser = mockUser;
      sessionHandler.userAuthStatus = UserAuthStatus.authorized;

      // Initialize CartController
      cartController = CartController();
      Get.put(cartController);
    });

    tearDown(() {
      Get.reset();
    });

    group('Discount Data Persistence', () {
      test('should save discount rate when updated', () async {
        // Arrange
        const testDiscountRate = 15.5;

        // Act
        cartController.updateDiscountRate(testDiscountRate.toString());

        // Wait for async operations to complete
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(cartController.cartDiscountRate.value, equals(testDiscountRate));
        expect(cartController.discountController.text,
            equals(testDiscountRate.toString()));

        // Verify data is saved to storage
        final userId = sessionHandler.currentUser!.id!;
        final discountRateKey = '${CacheKey.cartDiscountRate.name}_$userId';
        final savedValue =
            LocaleManager.instance.getStringValue(key: discountRateKey);
        expect(savedValue, equals(testDiscountRate.toString()));
      });

      test('should save description when changed', () async {
        // Arrange
        const testDescription = 'Test order description';

        // Act
        cartController.descriptionController.text = testDescription;
        cartController.onDescriptionChanged();

        // Wait for async operations to complete
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert
        expect(
            cartController.descriptionController.text, equals(testDescription));

        // Verify data is saved to storage
        final userId = sessionHandler.currentUser!.id!;
        final descriptionKey = '${CacheKey.cartDescription.name}_$userId';
        final savedValue =
            LocaleManager.instance.getStringValue(key: descriptionKey);
        expect(savedValue, equals(testDescription));
      });

      test('should load discount data on cart initialization', () async {
        // Arrange
        const testDiscountRate = 25.0;
        const testDescription = 'Loaded description';
        final userId = sessionHandler.currentUser!.id!;
        final discountRateKey = '${CacheKey.cartDiscountRate.name}_$userId';
        final descriptionKey = '${CacheKey.cartDescription.name}_$userId';

        // Pre-save data to storage
        await LocaleManager.instance.setStringValue(
          key: discountRateKey,
          value: testDiscountRate.toString(),
        );
        await LocaleManager.instance.setStringValue(
          key: descriptionKey,
          value: testDescription,
        );

        // Act
        await cartController.loadCartItems();

        // Assert
        expect(cartController.cartDiscountRate.value, equals(testDiscountRate));
        expect(cartController.discountController.text,
            equals(testDiscountRate.toString()));
        expect(
            cartController.descriptionController.text, equals(testDescription));
      });

      test('should clear discount data when cart is cleared', () async {
        // Arrange
        const testDiscountRate = 20.0;
        const testDescription = 'Test description';
        cartController.updateDiscountRate(testDiscountRate.toString());
        cartController.descriptionController.text = testDescription;
        cartController.onDescriptionChanged();

        // Wait for save operations
        await Future.delayed(const Duration(milliseconds: 100));

        // Act
        await cartController.clearCart();

        // Assert
        expect(cartController.cartDiscountRate.value, equals(0.0));
        expect(cartController.discountController.text, equals('0'));
        expect(cartController.descriptionController.text, isEmpty);

        // Verify data is cleared from storage
        final userId = sessionHandler.currentUser!.id!;
        final discountRateKey = '${CacheKey.cartDiscountRate.name}_$userId';
        final descriptionKey = '${CacheKey.cartDescription.name}_$userId';
        final savedDiscountRate =
            LocaleManager.instance.getStringValue(key: discountRateKey);
        final savedDescription =
            LocaleManager.instance.getStringValue(key: descriptionKey);
        expect(savedDiscountRate, isNull);
        expect(savedDescription, isNull);
      });

      test('should clear discount data for specific user on logout', () async {
        // Arrange
        const testDiscountRate = 30.0;
        const testDescription = 'User specific description';
        final userId = sessionHandler.currentUser!.id!;

        cartController.updateDiscountRate(testDiscountRate.toString());
        cartController.descriptionController.text = testDescription;
        cartController.onDescriptionChanged();

        // Wait for save operations
        await Future.delayed(const Duration(milliseconds: 100));

        // Verify data is saved
        final discountRateKey = '${CacheKey.cartDiscountRate.name}_$userId';
        final descriptionKey = '${CacheKey.cartDescription.name}_$userId';
        expect(LocaleManager.instance.getStringValue(key: discountRateKey),
            isNotNull);
        expect(LocaleManager.instance.getStringValue(key: descriptionKey),
            isNotNull);

        // Act
        await CartController.clearDiscountDataForUser(userId);

        // Assert
        final savedDiscountRate =
            LocaleManager.instance.getStringValue(key: discountRateKey);
        final savedDescription =
            LocaleManager.instance.getStringValue(key: descriptionKey);
        expect(savedDiscountRate, isNull);
        expect(savedDescription, isNull);
      });

      test('should handle invalid discount rate values gracefully', () async {
        // Arrange & Act
        cartController.updateDiscountRate('invalid');
        cartController.updateDiscountRate('-5');
        cartController.updateDiscountRate('150');

        // Assert - discount rate should remain unchanged for invalid values
        expect(cartController.cartDiscountRate.value, equals(0.0));
        expect(cartController.discountController.text, equals('0'));
      });

      test('should not save discount data when user is not logged in',
          () async {
        // Arrange
        sessionHandler.userAuthStatus = UserAuthStatus.unAuthorized;
        sessionHandler.currentUser = null;
        const testDiscountRate = 15.0;

        // Act
        cartController.updateDiscountRate(testDiscountRate.toString());

        // Wait for async operations
        await Future.delayed(const Duration(milliseconds: 100));

        // Assert - discount rate should be updated locally but not saved to storage
        expect(cartController.cartDiscountRate.value, equals(testDiscountRate));

        // Verify no data is saved to storage (since no user ID available)
        final discountRateKey = '${CacheKey.cartDiscountRate.name}_null';
        final savedValue =
            LocaleManager.instance.getStringValue(key: discountRateKey);
        expect(savedValue, isNull);
      });

      test('should handle user-specific storage keys correctly', () async {
        // Arrange
        const user1Id = 123;
        const user2Id = 456;
        const user1DiscountRate = 10.0;
        const user2DiscountRate = 20.0;

        // Act - Save data for user 1
        await LocaleManager.instance.setStringValue(
          key: '${CacheKey.cartDiscountRate.name}_$user1Id',
          value: user1DiscountRate.toString(),
        );

        // Save data for user 2
        await LocaleManager.instance.setStringValue(
          key: '${CacheKey.cartDiscountRate.name}_$user2Id',
          value: user2DiscountRate.toString(),
        );

        // Assert - Both users should have separate data
        final user1Data = LocaleManager.instance.getStringValue(
          key: '${CacheKey.cartDiscountRate.name}_$user1Id',
        );
        final user2Data = LocaleManager.instance.getStringValue(
          key: '${CacheKey.cartDiscountRate.name}_$user2Id',
        );

        expect(user1Data, equals(user1DiscountRate.toString()));
        expect(user2Data, equals(user2DiscountRate.toString()));

        // Clear data for user 1 only
        await CartController.clearDiscountDataForUser(user1Id);

        // Assert - Only user 1's data should be cleared
        final user1DataAfterClear = LocaleManager.instance.getStringValue(
          key: '${CacheKey.cartDiscountRate.name}_$user1Id',
        );
        final user2DataAfterClear = LocaleManager.instance.getStringValue(
          key: '${CacheKey.cartDiscountRate.name}_$user2Id',
        );

        expect(user1DataAfterClear, isNull);
        expect(user2DataAfterClear, equals(user2DiscountRate.toString()));
      });
    });
  });
}
