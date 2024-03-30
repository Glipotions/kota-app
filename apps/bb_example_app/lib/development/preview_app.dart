import 'package:bb_example_app/product/init/application_initialize.dart';
import 'package:bb_example_app/product/init/theme/module_theme.dart';
import 'package:bb_example_app/product/navigation/routing_manager.dart';
import 'package:common/common.dart';
// ignore: depend_on_referenced_packages
import 'package:device_preview/device_preview.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:values/values.dart';
import 'package:widgets/widget.dart';

///All environments call this function to run the app
Future<void> runPreview(EnvironmentConfigModel config) async {
  await ApplicationInitialize().make(config);
  runApp(
    DevicePreview(
      builder: (context) => PreviewApp(title: config.appName),
    ),
  );
}

///Starting Widget of app
class PreviewApp extends StatelessWidget {
  ///Starting Widget of app
  const PreviewApp({
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
                theme: getTheme(ModuleTheme(appColors: model.themeData)),
              );
            },
          );
        },
      ),
    );
  }
}
