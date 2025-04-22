import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:values/values.dart';

/// Color palette based on company configuration
class CompanyColors implements AbstractColor {
  /// Color palette based on company configuration
  CompanyColors({required this.companyConfig, this.isDark = false});

  /// Company configuration
  final CompanyConfigModel companyConfig;

  /// Whether to use dark mode
  final bool isDark;

  @override
  Brightness get brightness => isDark ? Brightness.dark : Brightness.light;

  @override
  String get themeCode => isDark ? 'dark' : 'light';

  @override
  Color get primary => companyConfig.primaryColor;

  @override
  Color get onPrimary => isDark ? Colors.white : Colors.black;

  @override
  Color get primaryContainer => _lighten(companyConfig.primaryColor, 0.15);
  
  @override
  Color get onPrimaryContainer => isDark ? Colors.white70 : Colors.black87;

  @override
  Color get secondary => companyConfig.secondaryColor;

  @override
  Color get onSecondary => isDark ? Colors.white : Colors.black;

  @override
  Color get secondaryContainer => _lighten(companyConfig.secondaryColor, 0.15);

  @override
  Color get onSecondaryContainer => isDark ? Colors.white70 : Colors.black87;

  @override
  Color get tertiary => _mix(companyConfig.primaryColor, companyConfig.secondaryColor, 0.5);

  @override
  Color get onTertiary => isDark ? Colors.white : Colors.black;

  @override
  Color get tertiaryContainer => _lighten(tertiary, 0.15);

  @override
  Color get onTertiaryContainer => isDark ? Colors.white70 : Colors.black87;

  // Error color palette
  @override
  Color get error => const Color(0xFFB3261E);

  @override
  Color get onError => const Color(0xFFFFFFFF);

  @override
  Color get errorContainer => const Color(0xFFF9DEDC);

  @override
  Color get onErrorContainer => const Color(0xFF410E0B);

  // Background and surface colors
  @override
  Color get outline => isDark ? const Color(0xFF3D3D3D) : const Color(0xFF79747E);

  @override
  Color get background => isDark ? const Color(0xFF121212) : const Color(0xFFFFFFFF);

  @override
  Color get onBackground => isDark ? const Color(0xFFE0E0E0) : const Color(0xFFF9F9F9);

  @override
  Color get surface => isDark ? const Color(0xFF1D1D1D) : const Color(0xFFFFFBFE);

  @override
  Color get onSurface => isDark ? const Color(0xFFE0E0E0) : const Color(0xFF1C1B1F);

  @override
  Color get surfaceVariant => isDark ? const Color(0xFF242424) : const Color(0xFFE7E0EC);

  @override
  Color get onSurfaceVariant => isDark ? const Color(0xFFBDBDBD) : const Color(0xFF49454F);

  @override
  Color get inverseSurface => isDark ? const Color(0xFFE0E0E0) : const Color(0xFF313033);

  @override
  Color get onInverseSurface => isDark ? const Color(0xFF121212) : const Color(0xFFF4EFF4);

  @override
  Color get inversePrimary => isDark ? _lighten(companyConfig.primaryColor, 0.2) : _darken(companyConfig.primaryColor, 0.2);

  @override
  Color get shadow => const Color(0xFF000000);

  @override
  Color get surfaceTint => companyConfig.primaryColor;

  @override
  Color get outlineVariant => isDark ? const Color(0xFF2A2A2A) : const Color(0xFFCAC4D0);

  @override
  Color get scrim => const Color(0xFF000000);

  // Helper methods to create color variations
  Color _lighten(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness + amount).clamp(0.0, 1.0)).toColor();
  }

  Color _darken(Color color, double amount) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - amount).clamp(0.0, 1.0)).toColor();
  }

  Color _mix(Color color1, Color color2, double weight) {
    return Color.lerp(color1, color2, weight) ?? color1;
  }
}
