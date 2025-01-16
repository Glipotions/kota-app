import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class LocalizationController extends GetxController {
  static LocalizationController get instance => Get.find<LocalizationController>();

  final _locale = const Locale('tr', 'TR').obs;
  Locale get locale => _locale.value;

  @override
  void onInit() {
    super.onInit();
    _locale.value = const Locale('tr', 'TR');
  }

  void changeLocale(Locale newLocale) {
    _locale.value = newLocale;
    Get.updateLocale(newLocale);
    update();
  }
}
