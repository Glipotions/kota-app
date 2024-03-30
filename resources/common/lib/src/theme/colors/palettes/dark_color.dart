import 'package:common/src/theme/colors/abstract_color.dart';
import 'package:flutter/material.dart';

/// Color palette for Dark Colors
class DarkColors implements AbstractColor {
  @override
  Brightness get brightness => Brightness.dark;

  @override
  String get themeCode => 'dark';

    @override
  Color get primary => const Color(0xFF42A5F5); // Canlı Mavi
  @override
  Color get onPrimary => const Color(0xFF0D47A1); // Karanlık Mavi Metin
  @override
  Color get primaryContainer => const Color(0xFF90CAF9); // Açık Canlı Mavi
  @override
  Color get onPrimaryContainer => const Color(0xFF1E88E5); // Parlak Mavi Metni

  @override
  Color get secondary => const Color(0xFF64B5F6); // Parlak Mavi
  @override
  Color get onSecondary => const Color(0xFF0D47A1); // Karanlık Mavi Metin
  @override
  Color get secondaryContainer => const Color(0xFFBBDEFB); // Soft Mavi
  @override
  Color get onSecondaryContainer => const Color(0xFF1565C0); // Canlı Mavi Metni

  @override
  Color get tertiary => const Color(0xFF4CAF509);
  @override
  Color get onTertiary => const Color(0xFF1565C0); // Canlı Mavi Metin
  @override
  Color get tertiaryContainer => const Color(0xFF42A5F5); // Gökyüzü Mavisi
  @override
  Color get onTertiaryContainer => const Color(0xFF1976D2); // Parlak Mavi Metni


  // Error color palette (can keep as it is or adjust for dark theme)
  @override
  Color get error => const Color(0xFFD32F2F);
  @override
  Color get onError => const Color(0xFFB71C1C);
  @override
  Color get errorContainer => const Color(0xFF3E2723);
  @override
  Color get onErrorContainer => const Color(0xFFFFCDD2);

  // The rest of the colors adjusted for dark theme
  @override
  Color get outline => const Color(0xFFBDBDBD);
  @override
  Color get background => const Color(0xFF303030);
  @override
  Color get onBackground => const Color(0xFF424242);
  @override
  Color get surface => const Color(0xFF37474F);
  @override
  Color get onSurface => const Color(0xFF78909C);
  @override
  Color get surfaceVariant => const Color(0xFF263238);
  @override
  Color get onSurfaceVariant => const Color(0xFFECEFF1);
  @override
  Color get inverseSurface => const Color(0xFFECEFF1);
  @override
  Color get onInverseSurface => const Color(0xFF212121);
  @override
  Color get inversePrimary => const Color(0xFF80CBC4);
  @override
  Color get shadow => const Color(0xFF000000);
  @override
  Color get surfaceTint => const Color(0xFF48A999);
  @override
  Color get outlineVariant => const Color(0xFF90A4AE);
  @override
  Color get scrim => const Color(0xFF000000);
}
