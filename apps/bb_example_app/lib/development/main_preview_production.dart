import 'package:bb_example_app/development/preview_app.dart';
import 'package:values/values.dart';

void main() {
  runPreview(
    EnvironmentConfigModel(
      appName: 'Dev App',
      environment: AppEnvironment.development,
      apiBaseUrl: 'rickandmortyapi.com',
      socketUrl: 'Socket Url',
    ),
  );
}
