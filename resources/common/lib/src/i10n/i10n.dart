import 'package:common/src/i10n/default_localization.dart';
import 'package:flutter/cupertino.dart';

///App Localization class manages labels and delegates
class AppLocalization<T extends AppLocalizationLabel> {
  const AppLocalization._(this.locale, this.labels);

  ///Locale value
  final Locale locale;

  ///Locale labels
  final T labels;

  ///Returns all labels for current context
  static AppLocalizationLabel getLabels (BuildContext context) {
    var localization = Localizations.of<AppLocalization>(
      context,
      AppLocalization,
    );
    localization ??= AppLocalization._(
      kDefaultLocal,
      supportedLocalization[kDefaultLocal.languageCode]!,
    );
    return localization.labels;
  }

  /// Returns delagates
  static AppLocalizationDelegate delegate = AppLocalizationDelegate();
}

/// AppLocalizationDelegate
class AppLocalizationDelegate extends LocalizationsDelegate<AppLocalization> {
  @override
  bool isSupported(Locale locale) {
    return supportedLocalization.containsKey(locale.languageCode);
  }

  @override
  Future<AppLocalization> load(Locale locale) async {
    final localization = AppLocalization<AppLocalizationLabel>._(
      locale,
      supportedLocalization[locale.languageCode]!,
    );
    return localization;
  }

  @override
  bool shouldReload(covariant LocalizationsDelegate<AppLocalization> old) {
    return false;
  }
}
