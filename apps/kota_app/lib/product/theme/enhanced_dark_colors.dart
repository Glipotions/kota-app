import 'package:common/common.dart';
import 'package:flutter/material.dart';

/// Enhanced dark color palette with improved contrast and readability
class EnhancedDarkColors implements AbstractColor {
  @override
  Brightness get brightness => Brightness.dark;

  @override
  String get themeCode => 'enhanced_dark';

  // Primary colors with better contrast
  @override
  Color get primary => const Color(0xFF4DABF5); // Brighter blue for better visibility

  @override
  Color get onPrimary => Colors.white;

  @override
  Color get primaryContainer => const Color(0xFF0D47A1); // Darker blue for containers

  @override
  Color get onPrimaryContainer => Colors.white;

  // Secondary colors with better contrast
  @override
  Color get secondary => const Color(0xFF66BB6A); // Brighter green

  @override
  Color get onSecondary => Colors.black;

  @override
  Color get secondaryContainer => const Color(0xFF2E7D32); // Darker green for containers

  @override
  Color get onSecondaryContainer => Colors.white;

  // Tertiary colors
  @override
  Color get tertiary => const Color(0xFFFFB74D); // Orange for accent

  @override
  Color get onTertiary => Colors.black;

  @override
  Color get tertiaryContainer => const Color(0xFFE65100); // Darker orange for containers

  @override
  Color get onTertiaryContainer => Colors.white;

  // Error colors with better visibility
  @override
  Color get error => const Color(0xFFFF5252); // Brighter red for errors

  @override
  Color get onError => Colors.white;

  @override
  Color get errorContainer => const Color(0xFFB71C1C); // Darker red for error containers

  @override
  Color get onErrorContainer => Colors.white;

  // Background colors with better contrast
  @override
  Color get background => const Color(0xFF121212); // Standard dark background

  @override
  Color get onBackground => const Color(0xFFF5F5F5); // Almost white for text

  // Surface colors with better contrast
  @override
  Color get surface => const Color(0xFF1E1E1E); // Slightly lighter than background

  @override
  Color get onSurface => const Color(0xFFEEEEEE); // Light gray for text on surface

  @override
  Color get surfaceVariant => const Color(0xFF2C2C2C); // Even lighter for variant surfaces

  @override
  Color get onSurfaceVariant => const Color(0xFFDDDDDD); // Slightly darker text for variants

  // Inverse colors
  @override
  Color get inverseSurface => const Color(0xFFEEEEEE);

  @override
  Color get onInverseSurface => const Color(0xFF121212);

  @override
  Color get inversePrimary => const Color(0xFF1565C0);

  // Other colors
  @override
  Color get outline => const Color(0xFF9E9E9E); // Medium gray for outlines

  @override
  Color get outlineVariant => const Color(0xFF757575); // Darker gray for variant outlines

  @override
  Color get shadow => Colors.black;

  @override
  Color get surfaceTint => primary.withOpacity(0.05);

  @override
  Color get scrim => Colors.black.withOpacity(0.5);
}
