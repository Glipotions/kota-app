// ignore_for_file: use_setters_to_change_properties,
// ignore_for_file: avoid_positional_boolean_parameters

import 'dart:ui';

import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:get/get.dart';
import 'package:kota_app/product/base/controller/base_controller.dart';
import 'package:kota_app/product/consts/claims.dart';
import 'package:kota_app/product/controllers/localization_controller.dart';
import 'package:kota_app/product/managers/cart_controller.dart';
import 'package:kota_app/product/theme/theme_manager.dart';
import 'package:kota_app/product/utility/enums/currency_type.dart';
import 'package:common/common.dart';

class ManageAccountController extends BaseControllerInterface {
  ManageAccountController() {
    _currentLanguage = Get.locale?.languageCode.obs ?? 'tr'.obs;
  }

  final _user = Rxn<User>();
  User? get user => _user.value;

  late final RxString _currentLanguage;
  String get currentLanguage => _currentLanguage.value;

  final _currentCurrency = Rxn<int>();
  int? get currentCurrency => _currentCurrency.value ?? 1;

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

  bool get canChangeCurrency => 
      sessionHandler.hasClaim(changeCurrencyAdminClaim) || kDebugMode;

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

    // Load currency from local storage or user data
    final savedCurrency = LocaleManager.instance.getIntValue(key: 'user_currency');
    if (savedCurrency != null) {
      _currentCurrency.value = savedCurrency;
      sessionHandler.currentUser?.currencyType = savedCurrency;
    } else {
      _currentCurrency.value = sessionHandler.currentUser?.currencyType;
    }
  }

  Future<void> changeCurrency(CurrencyType newCurrency) async {
    if (!canChangeCurrency) return;

    try {
      _currentCurrency.value = newCurrency.value;
      sessionHandler.currentUser?.currencyType = newCurrency.value;
      
      // Save currency to local storage
      await LocaleManager.instance.setIntValue(
        key: 'user_currency',
        value: newCurrency.value,
      );
      
      // Notify cart controller to update currency values
      if (Get.isRegistered<CartController>()) {
        Get.find<CartController>().updateCurrencyValues();
      }
    } catch (e) {
      // handleError(e);
    }
  }

  @override
  void onClose() {
    super.onClose();
  }

  void onTapRemoveAccount() {}
}
