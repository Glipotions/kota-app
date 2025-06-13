import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:kota_app/product/managers/session_handler.dart';
import 'package:kota_app/product/utility/extentions/num_extension.dart';

/// Extension for handling price display logic based on user authentication status
extension PriceDisplayExtension on num {
  /// Returns formatted price for authenticated users or placeholder for non-members
  /// 
  /// [context] - BuildContext for accessing localization
  /// [showPlaceholder] - Whether to show placeholder for non-members (default: true)
  /// [locale] - Optional locale for price formatting
  String formatPriceForUser(
    BuildContext context, {
    bool showPlaceholder = true,
    String? locale,
  }) {
    final sessionHandler = SessionHandler.instance;
    final isUserAuthenticated = sessionHandler.userAuthStatus == UserAuthStatus.authorized;
    
    if (isUserAuthenticated) {
      return formatPrice(locale: locale);
    } else if (showPlaceholder) {
      final labels = AppLocalization.getLabels(context);
      return labels.priceHiddenPlaceholder;
    } else {
      return '';
    }
  }
}

/// Utility class for price display widgets and components
class PriceDisplayHelper {
  /// Creates a price display widget that shows price for authenticated users
  /// or a placeholder with call-to-action for non-members
  static Widget buildPriceWidget(
    BuildContext context, {
    required num price,
    TextStyle? priceStyle,
    TextStyle? placeholderStyle,
    bool showLoginMessage = true,
    String? locale,
  }) {
    final sessionHandler = SessionHandler.instance;
    final isUserAuthenticated = sessionHandler.userAuthStatus == UserAuthStatus.authorized;
    final labels = AppLocalization.getLabels(context);
    
    if (isUserAuthenticated) {
      return Text(
        price.formatPrice(locale: locale),
        style: priceStyle,
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            labels.priceHiddenPlaceholder,
            style: placeholderStyle ?? priceStyle,
          ),
          if (showLoginMessage) ...[
            const SizedBox(height: 2),
            Text(
              labels.loginToSeePrices,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      );
    }
  }

  /// Creates a price display widget for discounted prices
  /// Shows original price (crossed out) and discounted price for authenticated users
  /// Shows placeholder for non-members
  static Widget buildDiscountedPriceWidget(
    BuildContext context, {
    required num originalPrice,
    required num discountedPrice,
    required double discountRate,
    TextStyle? originalPriceStyle,
    TextStyle? discountedPriceStyle,
    TextStyle? discountBadgeStyle,
    TextStyle? placeholderStyle,
    bool showLoginMessage = true,
    String? locale,
  }) {
    final sessionHandler = SessionHandler.instance;
    final isUserAuthenticated = sessionHandler.userAuthStatus == UserAuthStatus.authorized;
    final labels = AppLocalization.getLabels(context);
    
    if (isUserAuthenticated) {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                originalPrice.formatPrice(locale: locale),
                style: originalPriceStyle?.copyWith(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                ) ?? TextStyle(
                  decoration: TextDecoration.lineThrough,
                  color: Colors.grey,
                ),
              ),
              const SizedBox(width: 8),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(4),
                ),
                child: Text(
                  '%${discountRate.toStringAsFixed(0)}',
                  style: discountBadgeStyle?.copyWith(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                  ) ?? const TextStyle(
                    color: Colors.red,
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 4),
          Text(
            discountedPrice.formatPrice(locale: locale),
            style: discountedPriceStyle,
          ),
        ],
      );
    } else {
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            labels.priceHiddenPlaceholder,
            style: placeholderStyle ?? discountedPriceStyle,
          ),
          if (showLoginMessage) ...[
            const SizedBox(height: 2),
            Text(
              labels.loginToSeePrices,
              style: TextStyle(
                fontSize: 10,
                color: Colors.grey[600],
                fontStyle: FontStyle.italic,
              ),
            ),
          ],
        ],
      );
    }
  }

  /// Checks if the current user is authenticated
  static bool get isUserAuthenticated {
    return SessionHandler.instance.userAuthStatus == UserAuthStatus.authorized;
  }

  /// Gets the appropriate price text for display
  static String getPriceText(
    BuildContext context,
    num price, {
    String? locale,
  }) {
    return price.formatPriceForUser(context, locale: locale);
  }
}
