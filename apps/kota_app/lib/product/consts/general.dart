import 'package:get/get.dart';
import 'package:kota_app/product/theme/company_theme_manager.dart';

/// Default logo URL for Kota Tekstil
const String defaultLogoUrl = 'https://kota-app.b-cdn.net/logo.jpg';

/// Get the logo URL based on company configuration
String getLogoUrl() {
  try {
    if (Get.isRegistered<CompanyThemeManager>()) {
      final companyThemeManager = Get.find<CompanyThemeManager>();
      return companyThemeManager.companyConfig?.logoUrl ?? defaultLogoUrl;
    }
    return defaultLogoUrl;
  } catch (e) {
    return defaultLogoUrl;
  }
}
