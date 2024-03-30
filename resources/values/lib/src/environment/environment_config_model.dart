
import 'package:values/values.dart';

///Class that keeps environment specific values.
class EnvironmentConfigModel {
  ///Class that keeps environment specific values.
  EnvironmentConfigModel({
    required this.environment,
    required this.apiBaseUrl,
    required this.socketUrl,
    required this.appName,
  });

  ///Variable that keeps  current environment.
  ///[AppEnvironment.development] or [AppEnvironment.production]
  final AppEnvironment environment;

  ///Name of the app.
  final String appName;

  ///Environment specific api base url.
  final String apiBaseUrl;

  ///Environment specific socket base url.
  final String socketUrl;
}
