import 'package:common/src/i10n/lan/en.dart';
import 'package:common/src/i10n/lan/tr.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Locale;

/// Default Locale ayarlarımız
const Locale kDefaultLocal = Locale('tr');

/// Ugulamanın desteklediği diler
Map<String, AppLocalizationLabel> supportedLocalization = {
  'tr': TrLocalization(),
  'en': EnLocalization(),
};

///Function that returns all supported locales.
List<Locale> get getSupportedLocalList => List.generate(
      supportedLocalization.length,
      (int index) => Locale(
        supportedLocalization.keys.elementAt(index),
      ),
    );

///Abstrac class that keeps all texts.
abstract class AppLocalizationLabel {
  ///Abstrac class that keeps all texts.
  const AppLocalizationLabel();

  ///English
  String get localizationTitle;

  ///EN
  String get lanCode;

  ///An error occurred. Please try again later
  String get defaultErrorMessage;

  ///A server-related error occurred. Please try again later
  String get serverErrorMessage;

  ///Please check your internet connection.
  String get noInternetErrorMessage;

  ///You do not have the authority for this operation.
  String get unauthorizedErrorMessage;

  ///The connection has timed out
  String get timeoutErrorMessage;

  ///Cancel
  String get cancelBtnText;

  ///Try Again
  String get tryAgainBtnText;

  ///You should not be here :)
  String get unknownPageRouteMessageText;

  ///Welcome Back
  String get welcomeBack;

  ///Login to your Account
  String get loginToYourAccount;

  ///Login
  String get login;
  
  ///E-Mail
  String get eMail;

  ///Password
  String get password;

  ///Dashboard
  String get dashboard;

  ///Transactions
  String get transaction;

  ///Tasks
  String get task;

  ///Document
  String get document;

  ///Logout
  String get logout;

  ///Unknown
  String get unknown;

  ///This field is required
  String get requiredText;
  
  ///Please enter valid E-mail
  String get invalidMailText;
  ///Please enter valid name
  String get invalidNameText;
  ///Please enter valid E-mail
  String get invalidCreditCardNumberText;
  ///Please enter valid Credit Card Date
  String get invalidCreditCardDateText;
  ///Please enter valid Credit Card CVV
  String get invalidCreditCardCvvText;
  ///Please enter at least (n) char
  String atLeastLenghtText(int desiredLenght);
  ///Succesfully logged out
  String get succesfullyLoggedOut;
  ///Succesfully logged in
  String get succesfullyLoggedIn;


}
