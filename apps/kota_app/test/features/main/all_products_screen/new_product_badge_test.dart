import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:kota_app/product/widgets/badge/new_product_badge.dart';
import 'package:common/common.dart';

void main() {
  group('NewProductBadge Tests', () {
    testWidgets('should display localized "new" text', (WidgetTester tester) async {
      // Build the widget
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NewProductBadge(),
          ),
        ),
      );

      // Verify that the badge is displayed
      expect(find.byType(NewProductBadge), findsOneWidget);
      expect(find.byType(Container), findsOneWidget);
      expect(find.byType(Text), findsOneWidget);
    });

    testWidgets('should apply custom colors when provided', (WidgetTester tester) async {
      const customBackgroundColor = Colors.red;
      const customTextColor = Colors.yellow;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NewProductBadge(
              backgroundColor: customBackgroundColor,
              textColor: customTextColor,
            ),
          ),
        ),
      );

      // Find the container and text widgets
      final containerWidget = tester.widget<Container>(find.byType(Container));
      final textWidget = tester.widget<Text>(find.byType(Text));

      // Verify custom colors are applied
      final decoration = containerWidget.decoration as BoxDecoration;
      expect(decoration.color, equals(customBackgroundColor));
      expect(textWidget.style?.color, equals(customTextColor));
    });

    testWidgets('should apply custom font size when provided', (WidgetTester tester) async {
      const customFontSize = 14.0;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: NewProductBadge(
              fontSize: customFontSize,
            ),
          ),
        ),
      );

      final textWidget = tester.widget<Text>(find.byType(Text));
      expect(textWidget.style?.fontSize, equals(customFontSize));
    });
  });
}
