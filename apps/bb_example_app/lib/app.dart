import 'package:bb_example_app/product/init/application_initialize.dart';
import 'package:bb_example_app/product/init/theme/module_theme.dart';
import 'package:bb_example_app/product/navigation/routing_manager.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:universal_io/io.dart';
import 'package:values/values.dart';
import 'package:widgets/widget.dart';

///All environments call this function to run the app
Future<void> run(EnvironmentConfigModel config) async {
  await ApplicationInitialize().make(config);
  HttpOverrides.global = MyHttpOverrides();
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
              return MaterialApp.router(
                routerConfig: RoutingManager.instance.router,
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
                // darkTheme: ThemeData(
                //   // Dark mode tema ayarları
                //   primarySwatch: Colors.blue,
                //   brightness: Brightness.dark,
                // ),
                // themeMode: ThemeMode.system,
                theme: getTheme(ModuleTheme(appColors: model.themeData)),
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
