import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:kota_app/product/utility/enums/module_radius_enums.dart';

///Class that represent theme for whole module.
class ModuleTheme implements AppTheme {
  ///Class that represent theme for whole module.
  ModuleTheme({required this.appColors});

  ///Color palette that theme will use.
  AbstractColor appColors;


  @override
  IconThemeData get iconTheme => IconThemeData(color: appColors.primary);

  @override
  ProgressIndicatorThemeData get progressIndicatorTheme =>
      ProgressIndicatorThemeData(color: appColors.primary);

  @override
  ColorScheme get colorScheme => ColorScheme(
        primary: appColors.primary,
        primaryContainer: appColors.primaryContainer,
        secondary: appColors.secondary,
        secondaryContainer: appColors.secondaryContainer,
        tertiary: appColors.tertiary,
        surface: appColors.surface,
        background: appColors.background,
        error: appColors.error,
        onPrimary: appColors.onPrimary,
        onSecondary: appColors.onSecondary,
        onSurface: appColors.onSurface,
        onBackground: appColors.onBackground,
        onError: appColors.onError,
        brightness: appColors.brightness,
        outline: appColors.outline,
        errorContainer: appColors.errorContainer,
        inversePrimary: appColors.inversePrimary,
        outlineVariant: appColors.outlineVariant,
        inverseSurface: appColors.inverseSurface,
        onErrorContainer: appColors.onErrorContainer,
        onInverseSurface: appColors.onInverseSurface,
        onPrimaryContainer: appColors.onPrimaryContainer,
        onSecondaryContainer: appColors.onSecondaryContainer,
        onSurfaceVariant: appColors.onSurfaceVariant,
        onTertiary: appColors.onTertiary,
        onTertiaryContainer: appColors.onTertiaryContainer,
        scrim: appColors.scrim,
        shadow: appColors.shadow,
        surfaceTint: appColors.surfaceTint,
        surfaceContainerHighest: appColors.surfaceVariant,
        tertiaryContainer: appColors.tertiaryContainer,
      );

  @override
  CardThemeData get cardThemeData => CardThemeData(
        elevation: 0,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(
            ModuleRadius.m.value,
          ),
        ),
        color: appColors.onBackground,
        margin: EdgeInsets.zero,
      );

  @override
  TextTheme get textTheme => const TextTheme(
        displayLarge: TextStyle(
          fontSize: 96,
          fontWeight: FontWeight.w300,
          letterSpacing: -1.5,
        ),
        displayMedium: TextStyle(
          fontSize: 60,
          fontWeight: FontWeight.w300,
          letterSpacing: -0.5,
        ),
        displaySmall: TextStyle(
          fontSize: 48,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
        ),
        headlineLarge: TextStyle(
          fontSize: 42,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
        ),
        headlineMedium: TextStyle(
          fontSize: 34,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
        ),
        headlineSmall: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w400,
          letterSpacing: 0,
        ),
        titleLarge: TextStyle(
          fontSize: 20,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.15,
        ),
        titleMedium: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.15,
        ),
        titleSmall: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 0.1,
        ),
        bodyLarge: TextStyle(
          fontSize: 16,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.5,
        ),
        bodyMedium: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.25,
        ),
        labelLarge: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.25,
        ),
        labelMedium: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w500,
          letterSpacing: 1.25,
        ),
        bodySmall: TextStyle(
          fontSize: 12,
          fontWeight: FontWeight.w400,
          letterSpacing: 0.4,
        ),
        labelSmall: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w400,
          letterSpacing: 1.5,
        ),
      );

  @override
  ElevatedButtonThemeData get elevatedButtonTheme => ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          elevation: 0,
          backgroundColor: appColors.primary,
          foregroundColor: appColors.onPrimary,
          disabledBackgroundColor: appColors.secondary,
          disabledForegroundColor: appColors.onSecondary,
          fixedSize: const Size(double.infinity, 56),
          textStyle: TextStyle(
            color: appColors.onPrimary,
            fontWeight: FontWeight.w800,
            fontSize: 16,
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ModuleRadius.l.value),
          ),
        ),
      );

  @override
  InputDecorationTheme get inputDecorationTheme => InputDecorationTheme(
        filled: true,
        labelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w400,
          color: appColors.secondary,
        ),
        floatingLabelBehavior: FloatingLabelBehavior.never,
        hintStyle: TextStyle(
          fontWeight: FontWeight.w400,
          color: appColors.secondary,
          fontSize: 14,
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(
            ModuleRadius.s.value,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(
            ModuleRadius.s.value,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(
            ModuleRadius.s.value,
          ),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(
            ModuleRadius.s.value,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderSide: BorderSide.none,
          borderRadius: BorderRadius.circular(
            ModuleRadius.s.value,
          ),
        ),
      );

  @override
  TextSelectionThemeData get textSelectionThemeData => TextSelectionThemeData(
        cursorColor: appColors.primary,
        selectionColor: appColors.primary.withOpacity(0.2),
        selectionHandleColor: appColors.primary,
      );

  @override
  TextButtonThemeData get textButtonThemeData => TextButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
          foregroundColor: WidgetStateProperty.all<Color>(appColors.primary),
          shadowColor: WidgetStateProperty.all<Color>(Colors.transparent),
          overlayColor: WidgetStateProperty.all<Color>(Colors.transparent),
          textStyle: WidgetStateProperty.all<TextStyle>(
            TextStyle(
              color: appColors.primary,
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ),
        ),
      );

  @override
  OutlinedButtonThemeData get outlinedButtonThemeData =>
      OutlinedButtonThemeData(
        style: ButtonStyle(
          backgroundColor: WidgetStateProperty.all<Color>(Colors.transparent),
          foregroundColor:
              WidgetStateProperty.all<Color>(appColors.secondary),
          side: WidgetStateProperty.resolveWith((Set<WidgetState> states) {
            if (states.contains(WidgetState.disabled)) {
              return BorderSide(color: appColors.secondary);
            }
            return BorderSide(color: appColors.secondary);
          }),
          padding: WidgetStateProperty.all<EdgeInsets>(EdgeInsets.zero),
          textStyle: WidgetStateProperty.all<TextStyle>(
            TextStyle(
              color: appColors.secondary,
              fontWeight: FontWeight.w400,
              fontSize: 16,
            ),
          ),
          shape: WidgetStateProperty.all<RoundedRectangleBorder>(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(ModuleRadius.l.value),
            ),
          ),
        ),
      );

  @override
  CheckboxThemeData get checkboxThemeData => CheckboxThemeData(
        fillColor: WidgetStateProperty.all<Color?>(appColors.primary),
        checkColor: WidgetStateProperty.all<Color?>(appColors.onPrimary),
        side: BorderSide(width: 0.7, color: appColors.primary),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ModuleRadius.s.value),
        ),
      );

  @override
  RadioThemeData get radioThemeData => RadioThemeData(
        fillColor: WidgetStateProperty.all<Color>(appColors.primary),
      );

  @override
  DividerThemeData get dividerTheme => DividerThemeData(
        color: appColors.secondary,
        space: 0,
      );

  @override
  AppBarTheme get appBarTheme => AppBarTheme(
        titleSpacing: 0,
        elevation: 0,
        color: Colors.transparent,
        titleTextStyle: TextStyle(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: appColors.secondary,
        ),
        centerTitle: true,
        actionsIconTheme: IconThemeData(color: appColors.secondary),
        iconTheme: IconThemeData(color: appColors.primary),
      );

  @override
  TabBarThemeData get tabBarTheme => TabBarThemeData(
        labelColor: appColors.primary,
        labelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: appColors.primary,
        ),
        unselectedLabelColor: appColors.secondary,
        unselectedLabelStyle: TextStyle(
          fontSize: 14,
          fontWeight: FontWeight.w700,
          color: appColors.secondary,
        ),
      );

  @override
  Color get indicatorColor => appColors.primary;

  @override
  BottomAppBarTheme get bottomAppBarTheme => const BottomAppBarTheme(
        color: Colors.transparent,
        elevation: 0,
      );

  @override
  DialogThemeData get dialogTheme => DialogThemeData(
        backgroundColor: Colors.black54,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(ModuleRadius.m.value),
        ),
      );

  @override
  String get fontFamily => '';
}
