import 'package:flutter/material.dart';

/// Abstract class for defining the app theme.
abstract class AppTheme {
  /// Returns the font family for the app theme.
  String get fontFamily;



  /// Returns the default icon theme for the app theme.
  IconThemeData get iconTheme;

  /// Returns the color scheme for the app theme.
  ColorScheme get colorScheme;

  /// Returns the card theme for the app.
  CardTheme get cardTheme;

  /// Returns the text theme for the app.
  TextTheme get textTheme;

  /// Returns the elevated button theme for the app.
  ElevatedButtonThemeData get elevatedButtonTheme;

  /// Returns the input decoration theme for the app.
  InputDecorationTheme get inputDecorationTheme;

  /// Returns the text selection theme data for the app.
  TextSelectionThemeData get textSelectionThemeData;

  /// Returns the text button theme data for the app.
  TextButtonThemeData get textButtonThemeData;

  /// Returns the outlined button theme data for the app.
  OutlinedButtonThemeData get outlinedButtonThemeData;

  /// Returns the checkbox theme data for the app.
  CheckboxThemeData get checkboxThemeData;

  /// Returns the radio theme data for the app.
  RadioThemeData get radioThemeData;

  /// Returns the divider theme data for the app.
  DividerThemeData get dividerTheme;

  /// Returns the app bar theme for the app.
  AppBarTheme get appBarTheme;

  /// Returns the tab bar theme for the app.
  TabBarTheme get tabBarTheme;

  /// Returns the color for the indicator in the app.
  Color get indicatorColor;

  /// Returns the bottom app bar theme for the app.
  BottomAppBarTheme get bottomAppBarTheme;

  /// Returns the dialog theme for the app.
  DialogTheme get dialogTheme;

  /// Returns the progress indicator theme data for the app.
  ProgressIndicatorThemeData get progressIndicatorTheme;
}

/// Function to generate ThemeData based on the provided AppTheme.
ThemeData getTheme<T extends AppTheme>(T theme) => ThemeData(
      progressIndicatorTheme: theme.progressIndicatorTheme,
      cardTheme: theme.cardTheme,
      fontFamily: theme.fontFamily,
      textTheme: theme.textTheme,
      appBarTheme: theme.appBarTheme,
      iconTheme: theme.iconTheme,
      elevatedButtonTheme: theme.elevatedButtonTheme,
      textSelectionTheme: theme.textSelectionThemeData,
      inputDecorationTheme: theme.inputDecorationTheme,
      textButtonTheme: theme.textButtonThemeData,
      dividerTheme: theme.dividerTheme,
      outlinedButtonTheme: theme.outlinedButtonThemeData,
      checkboxTheme: theme.checkboxThemeData,
      radioTheme: theme.radioThemeData,
      tabBarTheme: theme.tabBarTheme,
      indicatorColor: theme.indicatorColor,
      bottomAppBarTheme: theme.bottomAppBarTheme,
      dialogTheme: theme.dialogTheme,
      colorScheme: theme.colorScheme,
    );
