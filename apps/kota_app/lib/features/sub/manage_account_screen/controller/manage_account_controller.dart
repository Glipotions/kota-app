// ignore_for_file: use_setters_to_change_properties,
// ignore_for_file: avoid_positional_boolean_parameters

import 'dart:ui';

import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota_app/product/base/controller/base_controller.dart';
import 'package:kota_app/product/controllers/localization_controller.dart';
import 'package:kota_app/product/theme/theme_manager.dart';

class ManageAccountController extends BaseControllerInterface {
  ManageAccountController() {
    _currentLanguage = Get.locale?.languageCode.obs ?? 'tr'.obs;
  }

  final _user = Rxn<User>();
  User? get user => _user.value;

  late final RxString _currentLanguage;
  String get currentLanguage => _currentLanguage.value;

  RxBool get isDarkMode => ThemeManager.instance.isDarkMode.obs;

  void setDarkMode(bool value) {
    ThemeManager.instance.toggleTheme(value);
  }

  void changeLanguage(String languageCode) {
    final countryCode = languageCode.toUpperCase();
    final localizationController = Get.find<LocalizationController>();
    localizationController.changeLocale(Locale(languageCode, countryCode));
    _currentLanguage.value = languageCode;
  }

  @override
  Future<void> onReady() async {
    await onReadyGeneric(_loadUserData);
  }

  Future<void> _loadUserData() async {
    _user.value = sessionHandler.currentUser;
    if (_user.value == null) {
      await sessionHandler.init();
      _user.value = sessionHandler.currentUser;
    }

    if (_user.value == null) {
      throw AppException('User data could not be loaded', 1);
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onTapRemoveAccount() {}
}
