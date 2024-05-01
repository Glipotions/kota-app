import 'package:bb_example_app/development/preview_app.dart';
import 'package:values/values.dart';

void main() {
  runPreview(
    EnvironmentConfigModel(
      appName: 'Prod App',
      environment: AppEnvironment.production,
      apiBaseUrl: 'rickandmortyapi.com',
      socketUrl: 'Socket Url',
    ),
  );
}
