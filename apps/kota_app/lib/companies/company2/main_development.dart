import 'package:kota_app/app.dart';
import 'package:values/values.dart';

/// DEV ENVIRONMENT FOR COMPANY 2
///
/// COMMAND LINE EXAMPLE
/// flutter run --flavor development lib/companies/company2/main_development.dart
/// flutter build apk --release --flavor development lib/companies/company2/main_development.dart --no-tree-shake-icons
/// flutter build appbundle --release --flavor development lib/companies/company2/main_development.dart
void main() {
  run(
    EnvironmentConfigModel(
      appName: 'Company 2 Dev',
      environment: AppEnvironment.development,
      apiBaseUrl: 'api.company2.com',
      socketUrl: 'Socket Url',
      companyConfig: CompanyConfigFactory.createCompany2(),
    ),
  );
}
