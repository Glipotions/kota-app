import 'dart:ui';

import 'package:common/common.dart';
import 'package:rxdart/rxdart.dart';
import 'package:universal_io/io.dart';

///This class is created for managing states that is valid for whole app.
class AppStateController {
  AppStateController._();
  static final AppStateController _instance = AppStateController._();

  ///This method returns instance for [AppStateController]
  static AppStateController get instance => _instance;

  ///This class has values that represent states for app.
  late AppStateModel model;

  ///Current available color palettes for app.
  late List<AbstractColor> availableColorPalettes;

  ///Current selected lan code for current user.
  late String lanCacheKey;

  ///Current selected theme color code for current user.
  late String themeCacheKey;

  final LocaleManager _localeManager = LocaleManager.instance;

  late final BehaviorSubject<AppStateModel> _model = BehaviorSubject.seeded(
    initialData(),
  );

  ///Returns app state model as  stream to refresh the app when needed.
  Stream<AppStateModel> get outModel => _model;

  ///Initializes the required values for [AppStateController].
  ///You have to initialize [AppStateController] before using any
  ///of its functioanlity.
  static Future<void> init({
    required List<AbstractColor> colorPalettes,
    required String themeKey,
    required String lanKey,
  }) async {
    _instance.availableColorPalettes = colorPalettes;
    _instance.themeCacheKey = themeKey;
    _instance.lanCacheKey = lanKey;
  }

  AbstractColor _initTheme() {
    if (getCurrentThemeCode==null) {
      final isPlatformDark =
          PlatformDispatcher.instance.platformBrightness == Brightness.dark;

      final theme = availableColorPalettes.firstWhere(
        (element) =>
            element.brightness ==
            (isPlatformDark ? Brightness.dark : Brightness.light),
        orElse: () => availableColorPalettes.first,
      );
      _localeManager.setStringValue(key: themeCacheKey, value: theme.themeCode);
      return theme;
    } else {
      return getColorDataByCode(getCurrentThemeCode!);
    }

    // return getColorDataByCode('light');
  }

  ///REturns color data based on theme code
  AbstractColor getColorDataByCode(String themeCode) =>
      availableColorPalettes.firstWhere(
        (element) => element.themeCode == themeCode,
        orElse: () => availableColorPalettes.first,
      );

  ///Initial data for materialController
  AppStateModel initialData() => model = AppStateModel(
        locale: _initLocale(),
        themeData: _initTheme(),
      );

  Locale _initLocale() {
    if (getCurrentLanCode == null) {
      var isLanguageExist = false;
      final userLanCode = Platform.localeName.split('-')[0];
      supportedLocalization.forEach((key, value) {
        if (value.lanCode == userLanCode) {
          isLanguageExist = true;
        }
      });
      _localeManager.setStringValue(
        key: lanCacheKey,
        value: isLanguageExist ? userLanCode : 'en',
      );

      return Locale(isLanguageExist ? userLanCode : 'en');
    } else {
      return Locale(_localeManager.getStringValue(key: lanCacheKey)!);
    }
  }

  ///Returns current theme code.
  String? get getCurrentThemeCode =>
      _localeManager.getStringValue(key: themeCacheKey);

  ///Returns current theme code.
  String? get getCurrentLanCode =>
      _localeManager.getStringValue(key: lanCacheKey);

  ///Sets the Theme, saves it to locale and updates the stream.
  void setTheme({
    required AbstractColor colorPalette,
  }) {
    _localeManager.setStringValue(
      key: themeCacheKey,
      value: colorPalette.themeCode,
    );
    _model.add(
      model.copyWith(
        themeData: colorPalette,
        locale: Locale(getCurrentLanCode!),
      ),
    );
  }

  ///Sets the Locale, saves it to locale and updates the stream.
  void setLocale(
    String lanCode,
  ) {
    _localeManager.setStringValue(key: lanCacheKey, value: lanCode);
    _model.add(
      model.copyWith(
        locale: Locale(lanCode),
        themeData: getColorDataByCode(getCurrentThemeCode!),
      ),
    );
  }
}
