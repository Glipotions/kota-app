import 'package:common/src/theme/colors/abstract_color.dart';
import 'package:flutter/material.dart';

/// Class that keeps color and locale data for app.
class AppStateModel {
  /// Class that keeps color and locale data for app.
  AppStateModel({required this.locale, required this.themeData});

  /// Locale value [Locale]
  final Locale locale;

  /// Color Palette [AbstractColor]
  final AbstractColor themeData;

  ///Method to generate copy of [AppStateModel]. Can be used to
  ///override fields.
  AppStateModel copyWith({
    Locale? locale,
    AbstractColor? themeData,
  }) =>
      AppStateModel(
        locale: locale ?? this.locale,
        themeData: themeData ?? this.themeData,
      );
}
