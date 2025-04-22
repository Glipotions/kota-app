import 'package:kota_app/app.dart';
import 'package:values/values.dart';

/// PROD ENVIRONMENT FOR COMPANY 2
///
/// COMMAND LINE EXAMPLE
/// flutter run --flavor product lib/companies/company2/main_production.dart
/// flutter build apk --release --flavor product lib/companies/company2/main_production.dart
/// flutter build appbundle --release --flavor product lib/companies/company2/main_production.dart

void main() {
  run(
    EnvironmentConfigModel(
      appName: 'Company 2',
      environment: AppEnvironment.production,
      apiBaseUrl: 'api.company2.com',
      socketUrl: 'Socket Url',
      companyConfig: CompanyConfigFactory.createCompany2(),
    ),
  );
}
