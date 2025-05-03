import 'package:kota_app/app.dart';
import 'package:values/values.dart';

/// DEV ENVIRONMENT FOR KOTA TEKSTIL
///
/// COMMAND LINE EXAMPLE
/// flutter run --flavor development lib/companies/kota_tekstil/main_development.dart
/// flutter build apk --release --flavor development lib/companies/kota_tekstil/main_development.dart --no-tree-shake-icons
/// flutter build appbundle --release --flavor development lib/companies/kota_tekstil/main_development.dart
void main() {
  run(
    EnvironmentConfigModel(
      appName: 'Kota Tekstil Dev',
      environment: AppEnvironment.development,
      // apiBaseUrl: '192.168.31.76:5278',
      apiBaseUrl: '78.186.131.20:8200',
      socketUrl: 'Socket Url',
      companyConfig: CompanyConfigFactory.createKotaTekstil(),
    ),
  );
}
