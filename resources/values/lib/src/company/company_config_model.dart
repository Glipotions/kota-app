import 'package:flutter/material.dart';

/// Class that keeps company specific values.
class CompanyConfigModel {
  /// Class that keeps company specific values.
  CompanyConfigModel({
    required this.companyId,
    required this.companyName,
    required this.appDisplayName,
    required this.logoUrl,
    required this.primaryColor,
    required this.secondaryColor,
    required this.apiBaseUrl,
    this.androidPackageId,
    this.iosAppId,
  });

  /// Unique identifier for the company
  final String companyId;

  /// Name of the company
  final String companyName;

  /// Display name of the app
  final String appDisplayName;

  /// URL for the company logo
  final String logoUrl;

  /// Primary color for the company theme
  final Color primaryColor;

  /// Secondary color for the company theme
  final Color secondaryColor;

  /// API base URL for the company
  final String apiBaseUrl;

  /// Android package ID (optional, can use default with suffix)
  final String? androidPackageId;

  /// iOS app ID (optional, can use default with suffix)
  final String? iosAppId;

  /// Create a copy of this model with the given fields replaced with the new values
  CompanyConfigModel copyWith({
    String? companyId,
    String? companyName,
    String? appDisplayName,
    String? logoUrl,
    Color? primaryColor,
    Color? secondaryColor,
    String? apiBaseUrl,
    String? androidPackageId,
    String? iosAppId,
  }) {
    return CompanyConfigModel(
      companyId: companyId ?? this.companyId,
      companyName: companyName ?? this.companyName,
      appDisplayName: appDisplayName ?? this.appDisplayName,
      logoUrl: logoUrl ?? this.logoUrl,
      primaryColor: primaryColor ?? this.primaryColor,
      secondaryColor: secondaryColor ?? this.secondaryColor,
      apiBaseUrl: apiBaseUrl ?? this.apiBaseUrl,
      androidPackageId: androidPackageId ?? this.androidPackageId,
      iosAppId: iosAppId ?? this.iosAppId,
    );
  }
}
