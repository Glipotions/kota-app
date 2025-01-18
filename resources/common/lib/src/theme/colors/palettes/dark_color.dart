import 'package:common/src/theme/colors/abstract_color.dart';
import 'package:flutter/material.dart';

/// Color palette for Dark Colors
class DarkColors implements AbstractColor {
  @override
  Brightness get brightness => Brightness.dark;

  @override
  String get themeCode => 'dark';

  /// Ana renk: Mevcut paletinizde kullanılan şeftali tonunu daha parlak bir tona çekerek,
  /// üzerine gelecek metinlerin (onPrimary) siyah olarak okunabilirliğini sağlamaya çalıştık.
  @override
  Color get primary => const Color(0xFFFFB599); // Daha parlak şeftali
  @override
  Color get onPrimary => const Color(0xFF000000); // Siyah metin

  @override
  Color get primaryContainer => const Color(0xFFFFCCBC); // Açık şeftali
  @override
  Color get onPrimaryContainer => const Color(0xFF442B2D); // Koyu kahverengi metin

  /// İkincil renk: Daha canlı ve doygun bir turuncu tonu seçildi.
  @override
  Color get secondary => const Color(0xFFFF8A65); // Canlı şeftali
  @override
  Color get onSecondary => const Color(0xFF000000); // Siyah metin

  @override
  Color get secondaryContainer => const Color(0xFFFFAB91); // Orta şeftali
  @override
  Color get onSecondaryContainer => const Color(0xFF000000); // Siyah metin

  /// Üçüncül renk: Bu renk için, açık tonlu kahverengi ailelerinden seçilerek kontrast sağlandı.
  @override
  Color get tertiary => const Color(0xFFFFCCBC); // Açık şeftali
  @override
  Color get onTertiary => const Color(0xFF442B2D); // Koyu kahverengi metin

  @override
  Color get tertiaryContainer => const Color(0xFFFFDED4); // Çok açık şeftali
  @override
  Color get onTertiaryContainer => const Color(0xFF442B2D); // Koyu kahverengi metin

  /// Hata renk paleti: Dark mod için tipik olarak kullanılan hata renkleri,
  /// daha belirgin kontrast ve okunabilirlik için ayarlandı.
  @override
  Color get error => const Color(0xFFFF6B6B);
  @override
  Color get onError => const Color(0xFF000000);
  @override
  Color get errorContainer => const Color(0xFFFFCDD2);
  @override
  Color get onErrorContainer => const Color(0xFF621B16);

  /// Arka plan ve yüzey renkleri: Dark modda genel arka plan, yüzey ve vurgulanacak alanlar
  /// için koyu tonlar kullanılırken, üzerlerindeki metinlerin okunurluğu için açık renkler tercih edildi.
  @override
  Color get outline => const Color(0xFF3D3D3D); // Koyu kenar rengi
  @override
  Color get background => const Color(0xFF121212); // Koyu arka plan
  @override
  Color get onBackground => const Color(0xFFE0E0E0); // Açık gri metin
  @override
  Color get surface => const Color(0xFF1D1D1D); // Daha açık card arka planı
  @override
  Color get onSurface => const Color(0xFFE0E0E0); // Açık gri metin
  @override
  Color get surfaceVariant => const Color(0xFF242424); // Alternatif card arka planı
  @override
  Color get onSurfaceVariant => const Color(0xFFBDBDBD); // Gri metin
  @override
  Color get inverseSurface => const Color(0xFFE0E0E0);
  @override
  Color get onInverseSurface => const Color(0xFF121212);

  /// Diğer yardımcı renkler: Kenarlıklar, gölgeler ve dokular için
  @override
  Color get inversePrimary => const Color(0xFFFFB599); // Şeftali rengi
  @override
  Color get shadow => const Color(0xFF000000);
  @override
  Color get surfaceTint => const Color(0xFFFFB599); // Şeftali rengi
  @override
  Color get outlineVariant => const Color(0xFF2A2A2A);
  @override
  Color get scrim => const Color(0xFF000000);
}