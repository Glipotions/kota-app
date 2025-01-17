import 'dart:async';

import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:kota_app/product/managers/local_notification_handler.dart';
import 'package:kota_app/product/service/product_client.dart';
import 'package:kota_app/product/utility/enums/cache_enums.dart';
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

    await ProductClient.clientInit(_config);

    await AppStateController.init(
      colorPalettes: [
        LightColors(),
        DarkColors(),
      ],
      themeKey: CacheKey.colorCode.name,
      lanKey: CacheKey.lanCode.name,
    );

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
      ),
    );

    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.landscapeLeft,
      DeviceOrientation.landscapeRight,
    ]);

    //  FirebaseMessagingService.messagingInit(
    //   showNotification: (title, body) => LocalNotificationHandler.instance
    //       .showNotification(title: title, body: body),
    // );

    await AppInfo.init();

    LocalNotificationHandler();

    FlutterError.onError = (details) {
      Logger().e(details.exceptionAsString());
    };
  }
}
