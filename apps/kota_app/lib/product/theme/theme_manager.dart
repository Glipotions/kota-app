import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota_app/product/init/theme/module_theme.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeManager extends GetxController {
  static ThemeManager get instance => Get.find<ThemeManager>();
  final _isDarkMode = false.obs;
  bool get isDarkMode => _isDarkMode.value;
  
  late SharedPreferences _prefs;
  static const String _themeKey = 'isDarkMode';

  late final ModuleTheme _lightTheme;
  late final ModuleTheme _darkTheme;

  ThemeData get lightTheme => getTheme(_lightTheme);
  ThemeData get darkTheme => getTheme(_darkTheme);

  @override
  void onInit() {
    super.onInit();
    _lightTheme = ModuleTheme(appColors: LightColors());
    _darkTheme = ModuleTheme(appColors: DarkColors());
  }

  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
    _isDarkMode.value = _prefs.getBool(_themeKey) ?? false;
    _updateTheme();
  }

  void toggleTheme(bool isDark) async {
    _isDarkMode.value = isDark;
    await _prefs.setBool(_themeKey, isDark);
    _updateTheme();
  }

  void _updateTheme() {
    Get.changeTheme(_isDarkMode.value ? darkTheme : lightTheme);
  }
}
