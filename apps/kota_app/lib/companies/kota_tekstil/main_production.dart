import 'package:kota_app/app.dart';
import 'package:values/values.dart';

/// PROD ENVIRONMENT FOR KOTA TEKSTIL
///
/// COMMAND LINE EXAMPLE
/// flutter run --flavor product lib/companies/kota_tekstil/main_production.dart
/// flutter build apk --release --flavor product lib/companies/kota_tekstil/main_production.dart
/// flutter build appbundle --release --flavor product lib/companies/kota_tekstil/main_production.dart

void main() {
  run(
    EnvironmentConfigModel(
      appName: 'Kota Tekstil',
      environment: AppEnvironment.production,
      apiBaseUrl: '78.186.131.20:8200',
      //apiBaseUrl: '192.168.31.76:5278',
      socketUrl: 'Socket Url',
      companyConfig: CompanyConfigFactory.createKotaTekstil(),
    ),
  );
}
