import 'package:flutter/material.dart';

///Abstract class that represent everything
///necessary for creating color palette.
abstract class AbstractColor {
  ///Theme code
  String get themeCode;

  ///Brightness of Color Palette
  Brightness get brightness;

  ///Primary
  Color get primary;

  ///OnPrimary
  Color get onPrimary;

  ///PrimaryContainer
  Color get primaryContainer;

  ///PrimaryContainer
  Color get onPrimaryContainer;

  ///Secondary
  Color get secondary;

  ///OnSecondary
  Color get onSecondary;

  ///PrimaryContainer
  Color get secondaryContainer;

  ///PrimaryContainer
  Color get onSecondaryContainer;

  ///Tertiary
  Color get tertiary;

  ///OnTertiary
  Color get onTertiary;

  ///OnTertiary
  Color get tertiaryContainer;

  ///OnTertiary
  Color get onTertiaryContainer;

  ///OnTertiary
  Color get error;

  ///OnTertiary
  Color get onError;

  ///OnTertiary
  Color get errorContainer;

  ///OnTertiary
  Color get onErrorContainer;

  ///OnTertiary
  Color get outline;

  ///OnTertiary
  Color get background;

  ///OnTertiary
  Color get onBackground;

  ///Scrim
  Color get scrim;

  ///Surface
  Color get surface;

  ///OnSurface
  Color get onSurface;

  ///OnSurface
  Color get surfaceVariant;

  ///OnSurface
  Color get onSurfaceVariant;

  ///OnSurface
  Color get inverseSurface;

  ///OnSurface
  Color get onInverseSurface;

  ///OnSurface
  Color get inversePrimary;

  ///OnSurface
  Color get shadow;

  ///OnSurface
  Color get surfaceTint;

  ///OnSurface
  Color get outlineVariant;
}
