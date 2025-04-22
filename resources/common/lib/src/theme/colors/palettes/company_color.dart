import 'package:common/src/theme/colors/abstract_color.dart';
import 'package:flutter/material.dart';

/// This file is intentionally left empty to avoid conflicts with the app's implementation.
/// The actual CompanyColors class is defined in the app package.
///
/// DO NOT USE THIS CLASS DIRECTLY.
/// Use the CompanyColors class from the app package instead.
class _CompanyConfigModel {
  final Color primaryColor = Colors.blue;
  final Color secondaryColor = Colors.green;
}

/// Placeholder class for company colors
class CompanyColorsPlaceholder implements AbstractColor {
  /// Constructor
  CompanyColorsPlaceholder({bool isDark = false}) : _isDark = isDark;

  final bool _isDark;
  final _config = _CompanyConfigModel();

  @override
  Brightness get brightness => _isDark ? Brightness.dark : Brightness.light;

  @override
  String get themeCode => _isDark ? 'dark' : 'light';

  @override
  Color get primary => Colors.blue;

  @override
  Color get onPrimary => _isDark ? Colors.white : Colors.black;

  @override
  Color get primaryContainer => Colors.blue.withOpacity(0.8);

  @override
  Color get onPrimaryContainer => _isDark ? Colors.white70 : Colors.black87;

  @override
  Color get secondary => Colors.green;

  @override
  Color get onSecondary => _isDark ? Colors.white : Colors.black;

  @override
  Color get secondaryContainer => Colors.green.withOpacity(0.8);

  @override
  Color get onSecondaryContainer => _isDark ? Colors.white70 : Colors.black87;

  @override
  Color get tertiary => Colors.orange;

  @override
  Color get onTertiary => _isDark ? Colors.white : Colors.black;

  @override
  Color get tertiaryContainer => Colors.orange.withOpacity(0.8);

  @override
  Color get onTertiaryContainer => _isDark ? Colors.white70 : Colors.black87;

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
  Color get outline => _isDark ? const Color(0xFF3D3D3D) : const Color(0xFF79747E);

  @override
  Color get background => _isDark ? const Color(0xFF121212) : const Color(0xFFFFFFFF);

  @override
  Color get onBackground => _isDark ? const Color(0xFFE0E0E0) : const Color(0xFFF9F9F9);

  @override
  Color get surface => _isDark ? const Color(0xFF1D1D1D) : const Color(0xFFFFFBFE);

  @override
  Color get onSurface => _isDark ? const Color(0xFFE0E0E0) : const Color(0xFF1C1B1F);

  @override
  Color get surfaceVariant => _isDark ? const Color(0xFF242424) : const Color(0xFFE7E0EC);

  @override
  Color get onSurfaceVariant => _isDark ? const Color(0xFFBDBDBD) : const Color(0xFF49454F);

  @override
  Color get inverseSurface => _isDark ? const Color(0xFFE0E0E0) : const Color(0xFF313033);

  @override
  Color get onInverseSurface => _isDark ? const Color(0xFF121212) : const Color(0xFFF4EFF4);

  @override
  Color get inversePrimary => _isDark ? Colors.blue.withOpacity(0.8) : Colors.blue.withOpacity(0.6);

  @override
  Color get shadow => const Color(0xFF000000);

  @override
  Color get surfaceTint => Colors.blue;

  @override
  Color get outlineVariant => _isDark ? const Color(0xFF2A2A2A) : const Color(0xFFCAC4D0);

  @override
  Color get scrim => const Color(0xFF000000);
}
