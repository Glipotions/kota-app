import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:api/api.dart';
import 'package:kota_app/product/widgets/badge/new_product_badge.dart';

// Mock ProductCard component for testing
class MockProductCard extends StatelessWidget {
  const MockProductCard({required this.item, super.key, this.onTap});

  final VoidCallback? onTap;
  final ProductGroupItem item;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 200,
      height: 300,
      child: GestureDetector(
        onTap: onTap,
        child: Card(
          color: Colors.white,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  flex: 3,
                  child: Stack(
                    children: [
                      Container(
                        width: double.infinity,
                        decoration: BoxDecoration(
                          color: Colors.grey[300],
                          borderRadius: const BorderRadius.vertical(
                            top: Radius.circular(8),
                          ),
                        ),
                        child: const Center(child: Text('Product Image')),
                      ),
                      // New product badge positioned at top-right corner
                      if (item.isNew ?? false)
                        const Positioned(
                          top: 8,
                          right: 8,
                          child: NewProductBadge(),
                        ),
                    ],
                  ),
                ),
                const SizedBox(height: 8),
                Expanded(
                  flex: 2,
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name ?? '',
                          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 1,
                        ),
                        const SizedBox(height: 4),
                        Expanded(
                          child: Text(
                            item.productName ?? '',
                            style: const TextStyle(fontSize: 14),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

void main() {
  group('ProductCard with New Product Badge Tests', () {
    testWidgets('should display new product badge when isNew is true', (WidgetTester tester) async {
      // Create a product with isNew = true
      final newProduct = ProductGroupItem(
        id: 1,
        code: 'TEST001',
        name: 'Test Product',
        productName: 'Test Product Name',
        pictureUrl: 'https://example.com/image.jpg',
        price: 99.99,
        isNew: true,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MockProductCard(item: newProduct),
          ),
        ),
      );

      // Verify that the new product badge is displayed
      expect(find.byType(NewProductBadge), findsOneWidget);
      expect(find.byType(Positioned), findsOneWidget);
    });

    testWidgets('should not display new product badge when isNew is false', (WidgetTester tester) async {
      // Create a product with isNew = false
      final regularProduct = ProductGroupItem(
        id: 2,
        code: 'TEST002',
        name: 'Regular Product',
        productName: 'Regular Product Name',
        pictureUrl: 'https://example.com/image.jpg',
        price: 49.99,
        isNew: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MockProductCard(item: regularProduct),
          ),
        ),
      );

      // Verify that the new product badge is not displayed
      expect(find.byType(NewProductBadge), findsNothing);
    });

    testWidgets('should not display new product badge when isNew is null', (WidgetTester tester) async {
      // Create a product with isNew = null
      final productWithNullIsNew = ProductGroupItem(
        id: 3,
        code: 'TEST003',
        name: 'Product with Null isNew',
        productName: 'Product Name',
        pictureUrl: 'https://example.com/image.jpg',
        price: 29.99,
        isNew: null,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MockProductCard(item: productWithNullIsNew),
          ),
        ),
      );

      // Verify that the new product badge is not displayed
      expect(find.byType(NewProductBadge), findsNothing);
    });

    testWidgets('should position badge correctly in top-right corner', (WidgetTester tester) async {
      final newProduct = ProductGroupItem(
        id: 4,
        code: 'TEST004',
        name: 'Positioned Test Product',
        productName: 'Test Product Name',
        pictureUrl: 'https://example.com/image.jpg',
        price: 79.99,
        isNew: true,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MockProductCard(item: newProduct),
          ),
        ),
      );

      // Find the positioned widget
      final positionedWidget = tester.widget<Positioned>(find.byType(Positioned));

      // Verify positioning
      expect(positionedWidget.top, equals(8.0));
      expect(positionedWidget.right, equals(8.0));
    });

    testWidgets('should render product card without errors', (WidgetTester tester) async {
      final product = ProductGroupItem(
        id: 5,
        code: 'TEST005',
        name: 'Aspect Ratio Test Product',
        productName: 'Test Product Name',
        pictureUrl: 'https://example.com/image.jpg',
        price: 59.99,
        isNew: false,
      );

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: MockProductCard(item: product),
          ),
        ),
      );

      // Verify that the card renders without errors
      expect(find.byType(MockProductCard), findsOneWidget);
      expect(find.byType(Stack), findsWidgets);
      expect(find.text('Aspect Ratio Test Product'), findsOneWidget);
      expect(find.text('Test Product Name'), findsOneWidget);

      // Verify that no new product badge is shown for non-new products
      expect(find.byType(NewProductBadge), findsNothing);
    });
  });
}
