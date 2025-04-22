
import 'package:values/src/company/company_config_model.dart';
import 'package:values/src/enum/general_enum.dart';

///Class that keeps environment specific values.
class EnvironmentConfigModel {
  ///Class that keeps environment specific values.
  EnvironmentConfigModel({
    required this.environment,
    required this.apiBaseUrl,
    required this.socketUrl,
    required this.appName,
    this.companyConfig,
  });

  ///Variable that keeps  current environment.
  ///[AppEnvironment.development] or [AppEnvironment.production]
  final AppEnvironment environment;

  ///Name of the app.
  final String appName;

  ///Environment specific api base url.
  final String apiBaseUrl;

  ///Environment specific socket base url.
  final String socketUrl;

  ///Company specific configuration.
  ///If null, the app will use default configuration.
  final CompanyConfigModel? companyConfig;

  ///Create a copy of this model with the given fields replaced with the new values
  EnvironmentConfigModel copyWith({
    AppEnvironment? environment,
    String? appName,
    String? apiBaseUrl,
    String? socketUrl,
    CompanyConfigModel? companyConfig,
  }) {
    return EnvironmentConfigModel(
      environment: environment ?? this.environment,
      appName: appName ?? this.appName,
      apiBaseUrl: apiBaseUrl ?? this.apiBaseUrl,
      socketUrl: socketUrl ?? this.socketUrl,
      companyConfig: companyConfig ?? this.companyConfig,
    );
  }
}
