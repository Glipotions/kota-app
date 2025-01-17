import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LocalizationController extends GetxController {
  static LocalizationController get instance => Get.find<LocalizationController>();
  static const String _languageKey = 'selected_language';

  final _locale = const Locale('tr', 'TR').obs;
  Locale get locale => _locale.value;

  @override
  void onInit() {
    super.onInit();
    _loadSavedLanguage();
  }

  Future<void> _loadSavedLanguage() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final savedLanguage = prefs.getString(_languageKey);
      if (savedLanguage != null) {
        final languageCode = savedLanguage.split('_')[0];
        final countryCode = savedLanguage.split('_')[1];
        _locale.value = Locale(languageCode, countryCode);
        Get.updateLocale(_locale.value);
        
        // AppStateController'ı güncelle
        AppStateController.instance.setLocale(languageCode);
      } else {
        // Eğer dil tercihi yoksa, AppStateController'dan mevcut dili al
        final currentLanCode = AppStateController.instance.getCurrentLanCode;
        if (currentLanCode != null) {
          _locale.value = Locale(currentLanCode, currentLanCode.toUpperCase());
          Get.updateLocale(_locale.value);
          
          // SharedPreferences'a kaydet
          await prefs.setString(_languageKey, '${currentLanCode}_${currentLanCode.toUpperCase()}');
        }
      }
    } catch (e) {
      debugPrint('Error loading language preference: $e');
      _locale.value = const Locale('tr', 'TR');
    }
  }

  Future<void> changeLocale(Locale newLocale) async {
    try {
      _locale.value = newLocale;
      Get.updateLocale(newLocale);
      
      // Dil tercihini kaydet
      final prefs = await SharedPreferences.getInstance();
      await prefs.setString(_languageKey, '${newLocale.languageCode}_${newLocale.countryCode}');
      
      // AppStateController'ı güncelle
      AppStateController.instance.setLocale(newLocale.languageCode);
      
      update();
    } catch (e) {
      debugPrint('Error saving language preference: $e');
    }
  }
}
