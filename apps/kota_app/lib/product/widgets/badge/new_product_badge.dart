import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:values/values.dart';

/// A reusable badge widget to indicate new products
/// 
/// This widget displays a "New" indicator badge that can be positioned
/// over product images or cards to highlight new products.
/// 
/// Features:
/// - Localized text support (Turkish/English/Arabic/Russian)
/// - Consistent styling with app design system
/// - Customizable positioning and colors
/// - Follows SOLID principles for reusability
class NewProductBadge extends StatelessWidget {
  const NewProductBadge({
    super.key,
    this.backgroundColor,
    this.textColor,
    this.fontSize,
  });

  /// Background color of the badge. Defaults to primary color if not provided.
  final Color? backgroundColor;
  
  /// Text color of the badge. Defaults to white if not provided.
  final Color? textColor;
  
  /// Font size of the badge text. Defaults to 10 if not provided.
  final double? fontSize;

  @override
  Widget build(BuildContext context) {
    final labels = AppLocalization.getLabels(context);
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: backgroundColor ?? context.primary,
        borderRadius: BorderRadius.circular(8),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.2),
            blurRadius: 2,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Text(
        labels.newProduct,
        style: TextStyle(
          color: textColor ?? Colors.white,
          fontSize: fontSize ?? 10,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }
}
