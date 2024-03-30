import 'package:bb_example_admin_panel/app.dart';
import 'package:values/values.dart';


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
