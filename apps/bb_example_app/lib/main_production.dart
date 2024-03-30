import 'package:bb_example_app/app.dart';
import 'package:values/values.dart';

/// PROD ENVIRONMENT
///
/// COMMAND LINE EXAMPLE
/// flutter run --flavor product lib/app/main/main_production.dart
/// flutter build apk --release --flavor product lib/app/main/main_production.dart
/// flutter build appbundle --release --flavor product lib/app/main/main_production.dart

void main() {
  run(
    EnvironmentConfigModel(
      appName: 'Prod App',
      environment: AppEnvironment.production,
      apiBaseUrl: 'rickandmortyapi.com',
      socketUrl: 'Socket Url',
    ),
  );
}
