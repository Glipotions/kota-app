import 'package:kota_app/app.dart';
import 'package:values/values.dart';

/// PROD ENVIRONMENT
///
/// COMMAND LINE EXAMPLE
/// flutter run --flavor product lib/main_production.dart
/// flutter build apk --release --flavor product lib/main_production.dart
/// flutter build appbundle --release --flavor product lib/main_production.dart

void main() {
  run(
    EnvironmentConfigModel(
      appName: 'Kota Prod App',
      environment: AppEnvironment.production,
      // apiBaseUrl: '192.168.31.76:5278',
      apiBaseUrl: '78.186.131.20:8200',
      socketUrl: 'Socket Url',
    ),
  );
}
