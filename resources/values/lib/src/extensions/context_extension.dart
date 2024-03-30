import 'package:common/common.dart';
import 'package:flutter/material.dart';

/// Flutter extension for the [BuildContext] class, providing convenient access
/// to commonly used theme properties and colors.
extension ContextExtension on BuildContext {
  /// Returns the large headline text style from the current theme.
  TextStyle get headlineLarge => Theme.of(this).textTheme.headlineLarge!;

  /// Returns the medium headline text style from the current theme.
  TextStyle get headlineMedium => Theme.of(this).textTheme.headlineMedium!;

  /// Returns the small headline text style from the current theme.
  TextStyle get headlineSmall => Theme.of(this).textTheme.headlineSmall!;

  /// Returns the large title text style from the current theme.
  TextStyle get titleLarge => Theme.of(this).textTheme.titleLarge!;

  /// Returns the medium title text style from the current theme.
  TextStyle get titleMedium => Theme.of(this).textTheme.titleMedium!;

  /// Returns the small title text style from the current theme.
  TextStyle get titleSmall => Theme.of(this).textTheme.titleSmall!;

  /// Returns the large body text style from the current theme.
  TextStyle get bodyLarge => Theme.of(this).textTheme.bodyLarge!;

  /// Returns the medium body text style from the current theme.
  TextStyle get bodyMedium => Theme.of(this).textTheme.bodyMedium!;

  /// Returns the small body text style from the current theme.
  TextStyle get bodySmall => Theme.of(this).textTheme.bodySmall!;

  /// Returns the large display text style from the current theme.
  TextStyle get displayLarge => Theme.of(this).textTheme.displayLarge!;

  /// Returns the medium display text style from the current theme.
  TextStyle get displayMedium => Theme.of(this).textTheme.displayMedium!;

  /// Returns the small display text style from the current theme.
  TextStyle get displaySmall => Theme.of(this).textTheme.displaySmall!;

  /// Returns the large label text style from the current theme.
  TextStyle get labelLarge => Theme.of(this).textTheme.labelLarge!;

  /// Returns the medium label text style from the current theme.
  TextStyle get labelMedium => Theme.of(this).textTheme.labelMedium!;

  /// Returns the small label text style from the current theme.
  TextStyle get labelSmall => Theme.of(this).textTheme.labelSmall!;

  /// Returns the primary color
  Color get primary => Theme.of(this).colorScheme.primary;

  /// Returns the onPrimary color
  Color get onPrimary => Theme.of(this).colorScheme.onPrimary;

  /// Returns the primaryContainer color
  Color get primaryContainer => Theme.of(this).colorScheme.primaryContainer;

  /// Returns the onPrimaryContainer color
  Color get onPrimaryContainer => Theme.of(this).colorScheme.onPrimaryContainer;

  /// Returns the secondary color
  Color get secondary => Theme.of(this).colorScheme.secondary;

  /// Returns the onSecondary color
  Color get onSecondary => Theme.of(this).colorScheme.onSecondary;

  /// Returns the secondaryContainer color
  Color get secondaryContainer => Theme.of(this).colorScheme.secondaryContainer;

  /// Returns the onSecondaryContainer color
  Color get onSecondaryContainer =>
      Theme.of(this).colorScheme.onSecondaryContainer;

  /// Returns the tertiary color
  Color get tertiary => Theme.of(this).colorScheme.tertiary;

  /// Returns the onTertiary color
  Color get onTertiary => Theme.of(this).colorScheme.onTertiary;

  /// Returns the tertiaryContainer color
  Color get tertiaryContainer => Theme.of(this).colorScheme.tertiaryContainer;

  /// Returns the onTertiaryContainer color
  Color get onTertiaryContainer =>
      Theme.of(this).colorScheme.onTertiaryContainer;

  /// Returns the error color
  Color get error => Theme.of(this).colorScheme.error;

  /// Returns the onError color
  Color get onError => Theme.of(this).colorScheme.onError;

  /// Returns the errorContainer color
  Color get errorContainer => Theme.of(this).colorScheme.errorContainer;

  /// Returns the onErrorContainer color
  Color get onErrorContainer => Theme.of(this).colorScheme.onErrorContainer;

  /// Returns the outline color
  Color get outline => Theme.of(this).colorScheme.outline;

  /// Returns the background color
  Color get background => Theme.of(this).colorScheme.background;

  /// Returns the onBackground color
  Color get onBackground => Theme.of(this).colorScheme.onBackground;

  /// Returns the surface color
  Color get surface => Theme.of(this).colorScheme.surface;

  /// Returns the onSurface color
  Color get onSurface => Theme.of(this).colorScheme.onSurface;

  /// Returns the surfaceVariant color
  Color get surfaceVariant => Theme.of(this).colorScheme.surfaceVariant;

  /// Returns the onSurfaceVariant color
  Color get onSurfaceVariant => Theme.of(this).colorScheme.onSurfaceVariant;

  /// Returns the inverseSurface color
  Color get inverseSurface => Theme.of(this).colorScheme.inverseSurface;

  /// Returns the onInverseSurface color
  Color get onInverseSurface => Theme.of(this).colorScheme.onInverseSurface;

  /// Returns the inversePrimary color
  Color get inversePrimary => Theme.of(this).colorScheme.inversePrimary;

  /// Returns the shadow color
  Color get shadow => Theme.of(this).colorScheme.shadow;

  /// Returns the surfaceTint color
  Color get surfaceTint => Theme.of(this).colorScheme.surfaceTint;

  /// Returns the outlineVariant color
  Color get outlineVariant => Theme.of(this).colorScheme.outlineVariant;

  /// Returns the scrim color
  Color get scrim => Theme.of(this).colorScheme.scrim;

  /// Returns the brightness from the current theme's color scheme.
  Brightness get brightness => Theme.of(this).colorScheme.brightness;
  
   /// Returns Localization Label
  AppLocalizationLabel get i10n =>AppLocalization.getLabels(this);
}
