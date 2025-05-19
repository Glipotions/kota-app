import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:kota_app/product/init/theme/module_theme.dart';
import 'package:kota_app/product/theme/company_colors.dart';
import 'package:kota_app/product/theme/enhanced_dark_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:values/values.dart';

// Using CompanyConfigModel from values package

/// Abstract class for company theme providers
/// This follows the Dependency Inversion Principle by defining an abstraction
abstract class ICompanyThemeProvider {
  /// Get the light theme for the company
  ThemeData getLightTheme();

  /// Get the dark theme for the company
  ThemeData getDarkTheme();

  /// Whether dark mode is enabled
  bool get isDarkMode;

  /// Toggle between light and dark theme
  Future<void> toggleTheme({required bool isDark});

  /// Initialize the theme provider
  Future<void> init();
}

/// Implementation of company theme provider using CompanyConfigModel
class CompanyThemeProvider implements ICompanyThemeProvider {
  /// Constructor
  CompanyThemeProvider({required this.companyConfig});

  /// Company configuration
  final CompanyConfigModel companyConfig;

  late final ModuleTheme _lightTheme;
  late final ModuleTheme _darkTheme;

  bool _isDarkMode = false;

  @override
  bool get isDarkMode => _isDarkMode;

  late SharedPreferences _prefs;
  static const String _themeKey = 'isDarkMode';

  @override
  ThemeData getLightTheme() {
    return getTheme(_lightTheme);
  }

  @override
  ThemeData getDarkTheme() {
    return getTheme(_darkTheme);
  }

  /// Initialize themes
  void _initThemes() {
    _lightTheme = ModuleTheme(
      appColors: CompanyColors(
        companyConfig: companyConfig,
      ),
    );

    // Use enhanced dark theme for better contrast and readability
    _darkTheme = ModuleTheme(
      appColors: EnhancedDarkColors(),
    );
  }

  @override
  Future<void> init() async {
    _initThemes();
    _prefs = await SharedPreferences.getInstance();
    _isDarkMode = _prefs.getBool(_themeKey) ?? false;
  }

  @override
  Future<void> toggleTheme({required bool isDark}) async {
    _isDarkMode = isDark;
    await _prefs.setBool(_themeKey, isDark);
  }
}

/// Default theme provider that uses the default app colors
class DefaultThemeProvider implements ICompanyThemeProvider {
  late final ModuleTheme _lightTheme;
  late final ModuleTheme _darkTheme;

  bool _isDarkMode = false;

  @override
  bool get isDarkMode => _isDarkMode;

  late SharedPreferences _prefs;
  static const String _themeKey = 'isDarkMode';

  @override
  ThemeData getLightTheme() {
    return getTheme(_lightTheme);
  }

  @override
  ThemeData getDarkTheme() {
    return getTheme(_darkTheme);
  }

  /// Initialize themes
  void _initThemes() {
    _lightTheme = ModuleTheme(appColors: LightColors());
    _darkTheme = ModuleTheme(appColors: EnhancedDarkColors());
  }

  @override
  Future<void> init() async {
    _initThemes();
    _prefs = await SharedPreferences.getInstance();
    _isDarkMode = _prefs.getBool(_themeKey) ?? false;
  }

  @override
  Future<void> toggleTheme({required bool isDark}) async {
    _isDarkMode = isDark;
    await _prefs.setBool(_themeKey, isDark);
  }
}
