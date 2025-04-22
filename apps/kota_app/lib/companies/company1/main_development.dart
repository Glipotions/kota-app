import 'package:kota_app/app.dart';
import 'package:values/values.dart';

/// DEV ENVIRONMENT FOR COMPANY 1
///
/// COMMAND LINE EXAMPLE
/// flutter run --flavor development lib/companies/company1/main_development.dart
/// flutter build apk --release --flavor development lib/companies/company1/main_development.dart --no-tree-shake-icons
/// flutter build appbundle --release --flavor development lib/companies/company1/main_development.dart
void main() {
  run(
    EnvironmentConfigModel(
      appName: 'Company 1 Dev',
      environment: AppEnvironment.development,
      apiBaseUrl: 'api.company1.com',
      socketUrl: 'Socket Url',
      companyConfig: CompanyConfigFactory.createCompany1(),
    ),
  );
}
