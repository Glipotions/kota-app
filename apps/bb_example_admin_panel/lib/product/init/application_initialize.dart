import 'dart:async';

import 'package:bb_example_admin_panel/product/service/product_client.dart';
import 'package:bb_example_admin_panel/product/utility/enums/cache_enums.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
// ignore: depend_on_referenced_packages
import 'package:flutter_web_plugins/url_strategy.dart';
import 'package:logger/logger.dart';
import 'package:values/values.dart';

///Class that handles required initialazations for the app.
class ApplicationInitialize {
  late EnvironmentConfigModel _config;

  ///Method that initialize app for given [EnvironmentConfigModel]
  Future<void> make(EnvironmentConfigModel config) async {
    _config = config;
    WidgetsFlutterBinding.ensureInitialized();

    await runZonedGuarded<Future<void>>(
      _initialize,
      (error, stack) {
        Logger().e(error);
      },
    );
  }

  Future<void> _initialize() async {
    WidgetsFlutterBinding.ensureInitialized();
    await LocaleManager.cacheInit();

    usePathUrlStrategy();

    // LocalNotificationHandler.instance;
    await ProductClient.clientInit(_config);

    await AppStateController.init(
      colorPalettes: [
        LightColors(),
        DarkColors(),
      ],
      lanKey: CacheKey.colorCode.name,
      themeKey: CacheKey.lanCode.name,
    );


    FlutterError.onError = (details) {
      Logger().e(details.exceptionAsString());
    };
  }
}
