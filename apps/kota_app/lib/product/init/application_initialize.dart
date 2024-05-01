import 'dart:async';
import 'package:bb_example_app/product/managers/local_notification_handler.dart';
import 'package:bb_example_app/product/service/product_client.dart';
import 'package:bb_example_app/product/utility/enums/cache_enums.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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

    SystemChrome.setSystemUIOverlayStyle(
      const SystemUiOverlayStyle(
        systemNavigationBarColor: Colors.transparent,
        systemNavigationBarDividerColor: Colors.transparent,
        statusBarBrightness: Brightness.dark,
      ),
    );

    await SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);

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
