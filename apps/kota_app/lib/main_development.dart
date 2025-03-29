import 'package:kota_app/app.dart';
import 'package:values/values.dart';

/// DEV ENVIRONMENT
///
/// COMMAND LINE EXAMPLE
/// flutter run --flavor development lib/app/main/main_development.dart
/// flutter build apk --release --flavor development lib/app/main/main_development.dart --no-tree-shake-icons
/// flutter build appbundle --release --flavor development lib/app/main/main_development.dart
void main() {
  run(
    EnvironmentConfigModel(
      appName: 'Dev App',
      environment: AppEnvironment.development,
      // apiBaseUrl: '192.168.31.160:5278',
      // apiBaseUrl: '192.168.1.137:5278',
      apiBaseUrl: '78.186.131.20:8200',
      socketUrl: 'Socket Url',
    ),
  );
}
