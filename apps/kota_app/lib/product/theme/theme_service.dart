import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota_app/product/theme/company_theme_provider.dart';
import 'package:values/values.dart';

/// Service for managing themes
/// This follows the Service Locator pattern
class ThemeService extends GetxController {
  /// Get the singleton instance
  static ThemeService get instance => Get.find<ThemeService>();

  late final ICompanyThemeProvider _themeProvider;

  /// Constructor
  ThemeService({CompanyConfigModel? companyConfig}) {
    _themeProvider = companyConfig != null
        ? CompanyThemeProvider(companyConfig: companyConfig)
        : DefaultThemeProvider();
  }

  /// Whether dark mode is enabled
  bool get isDarkMode => _themeProvider.isDarkMode;

  /// Light theme
  ThemeData get lightTheme => _themeProvider.getLightTheme();

  /// Dark theme
  ThemeData get darkTheme => _themeProvider.getDarkTheme();

  /// Initialize the theme service
  Future<void> init() async {
    await _themeProvider.init();
    _updateTheme();
  }

  /// Toggle between light and dark theme
  Future<void> toggleTheme({required bool isDark}) async {
    await _themeProvider.toggleTheme(isDark: isDark);
    _updateTheme();
  }

  void _updateTheme() {
    Get.changeTheme(isDarkMode ? darkTheme : lightTheme);
  }
}
