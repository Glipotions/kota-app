import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota_app/product/init/theme/module_theme.dart';
import 'package:kota_app/product/theme/company_colors.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:values/values.dart';

/// Theme manager that uses company configuration
class CompanyThemeManager extends GetxController {
  /// Constructor
  CompanyThemeManager({this.companyConfig});

  /// Get the singleton instance
  static CompanyThemeManager get instance => Get.find<CompanyThemeManager>();

  final _isDarkMode = false.obs;

  /// Whether dark mode is enabled
  bool get isDarkMode => _isDarkMode.value;

  late SharedPreferences _prefs;
  static const String _themeKey = 'isDarkMode';

  late final ModuleTheme _lightTheme;
  late final ModuleTheme _darkTheme;

  /// Company configuration
  final CompanyConfigModel? companyConfig;

  /// Light theme
  ThemeData get lightTheme => getTheme(_lightTheme);

  /// Dark theme
  ThemeData get darkTheme => getTheme(_darkTheme);

  @override
  void onInit() {
    super.onInit();
    if (companyConfig != null) {
      _lightTheme = ModuleTheme(
        appColors: CompanyColors(
          companyConfig: companyConfig!,
          isDark: false,
        ),
      );
      _darkTheme = ModuleTheme(
        appColors: CompanyColors(
          companyConfig: companyConfig!,
          isDark: true,
        ),
      );
    } else {
      _lightTheme = ModuleTheme(appColors: LightColors());
      _darkTheme = ModuleTheme(appColors: DarkColors());
    }
  }

  /// Initialize theme preferences
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _isDarkMode.value = _prefs.getBool(_themeKey) ?? false;
    _updateTheme();
  }

  /// Toggle between light and dark theme
  Future<void> toggleTheme({required bool isDark}) async {
    _isDarkMode.value = isDark;
    await _prefs.setBool(_themeKey, isDark);
    _updateTheme();
  }

  void _updateTheme() {
    Get.changeTheme(_isDarkMode.value ? darkTheme : lightTheme);
  }
}
