import 'package:flutter/material.dart';
import 'package:values/src/company/company_config_model.dart';

/// Class that provides predefined company configurations
class PredefinedCompanies {
  PredefinedCompanies._();

  /// Kota Tekstil company configuration
  static final CompanyConfigModel kotaTekstil = CompanyConfigModel(
    companyId: 'kota_tekstil',
    companyName: 'Kota Tekstil',
    appDisplayName: 'Kota İç Giyim',
    logoUrl: 'https://kota-app.b-cdn.net/logo.jpg',
    primaryColor: const Color(0xFFFBD4C6), // Peachy color from the app icon
    secondaryColor: const Color(0xFF333333),
    apiBaseUrl: '78.186.131.20:8200',
    //apiBaseUrl: '192.168.31.76:5278',
    androidPackageId: 'com.glipotions.kota_app',
    iosAppId: 'com.glipotions.kota.app',
  );

  /// Example Company 1 configuration
  static final CompanyConfigModel company1 = CompanyConfigModel(
    companyId: 'company1',
    companyName: 'Company 1',
    appDisplayName: 'Company 1 App',
    logoUrl: 'https://example.com/company1/logo.jpg',
    primaryColor: const Color(0xFF4CAF50), // Green
    secondaryColor: const Color(0xFF2196F3), // Blue
    apiBaseUrl: 'api.company1.com',
    androidPackageId: 'com.glipotions.company1_app',
    iosAppId: 'com.glipotions.company1.app',
  );

  /// Example Company 2 configuration
  static final CompanyConfigModel company2 = CompanyConfigModel(
    companyId: 'company2',
    companyName: 'Company 2',
    appDisplayName: 'Company 2 App',
    logoUrl: 'https://example.com/company2/logo.jpg',
    primaryColor: const Color(0xFFF44336), // Red
    secondaryColor: const Color(0xFF9C27B0), // Purple
    apiBaseUrl: 'api.company2.com',
    androidPackageId: 'com.glipotions.company2_app',
    iosAppId: 'com.glipotions.company2.app',
  );

  /// Get company configuration by ID
  static CompanyConfigModel getCompanyById(String companyId) {
    switch (companyId) {
      case 'kota_tekstil':
        return kotaTekstil;
      case 'company1':
        return company1;
      case 'company2':
        return company2;
      default:
        return kotaTekstil; // Default to Kota Tekstil
    }
  }
}
