import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:get/get.dart';
import 'package:kota_app/product/controllers/localization_controller.dart';
import 'package:kota_app/product/init/application_initialize.dart';
import 'package:kota_app/product/navigation/routing_manager.dart';
import 'package:kota_app/product/theme/theme_manager.dart';
import 'package:universal_io/io.dart';
import 'package:values/values.dart';
import 'package:widgets/widget.dart';

///All environments call this function to run the app
Future<void> run(EnvironmentConfigModel config) async {
  await ApplicationInitialize().make(config);
  HttpOverrides.global = MyHttpOverrides();
  
  // Initialize controllers
  Get.put(LocalizationController(), permanent: true);
  final themeManager = Get.put(ThemeManager(), permanent: true);
  await themeManager.init();
  
  runApp(App(title: config.appName));
}

///Starting Widget of app
class App extends StatelessWidget {
  ///Starting Widget of app
  const App({
    required this.title,
    super.key,
  });

  ///Current title of the app that comes from [EnvironmentConfigModel]
  final String title;

  @override
  Widget build(BuildContext context) {
    return BaseOverlay(
      child: MaterialRxStreamBuilder(
        stream: AppStateController.instance.outModel,
        builder: (_, snapshot) {
          final model = snapshot.data;
          return LayoutBuilder(
            builder: (BuildContext context, BoxConstraints constraints) {
              return GetMaterialApp.router(
                routerDelegate: RoutingManager.instance.router.routerDelegate,
                routeInformationParser: RoutingManager.instance.router.routeInformationParser,
                routeInformationProvider: RoutingManager.instance.router.routeInformationProvider,
                backButtonDispatcher: RoutingManager.instance.router.backButtonDispatcher,
                locale: model!.locale,
                supportedLocales: getSupportedLocalList,
                localizationsDelegates: [
                  GlobalMaterialLocalizations.delegate,
                  GlobalWidgetsLocalizations.delegate,
                  GlobalCupertinoLocalizations.delegate,
                  AppLocalization.delegate,
                ],
                builder: (BuildContext context, Widget? child) {
                  return MediaQuery(
                    data: MediaQuery.of(context).copyWith(
                      textScaler: TextScaler.noScaling,
                    ),
                    child: child!,
                  );
                },
                scrollBehavior: ScrollConfiguration.of(context).copyWith(
                  overscroll: false,
                ),
                title: title,
                debugShowCheckedModeBanner: false,
                theme: ThemeManager.instance.lightTheme,
                darkTheme: ThemeManager.instance.darkTheme,
                themeMode: ThemeManager.instance.isDarkMode ? ThemeMode.dark : ThemeMode.light,
              );
            },
          );
        },
      ),
    );
  }
}

class MyHttpOverrides extends HttpOverrides {
  @override
  HttpClient createHttpClient(SecurityContext? context) {
    return super.createHttpClient(context)
      ..badCertificateCallback =
          (X509Certificate cert, String host, int port) => true;
  }
}
