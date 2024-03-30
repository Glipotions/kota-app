import 'package:common/src/i10n/default_localization.dart';

///Localization File For English - EN
class EnLocalization extends AppLocalizationLabel {
  @override
  final String lanCode = 'en';

  @override
  final String localizationTitle = 'English';

  @override
  final String defaultErrorMessage =
      'An error occurred. Please try again later';
  @override
  final String noInternetErrorMessage =
      'Please check your internet connection.';
  @override
  final String unauthorizedErrorMessage =
      'You do not have authorization for this operation.';
  @override
  final String serverErrorMessage =
      'A server-side error occurred. Please try again later';
  @override
  final String cancelBtnText = 'Cancel';
  @override
  final String tryAgainBtnText = 'Try Again';

  @override
  String get timeoutErrorMessage => 'Connection timed out';

  @override
  String get unknownPageRouteMessageText => "You shouldn't be here :)";

  @override
  String get eMail => 'E-Mail';

  @override
  String get login => 'Log In';

  @override
  String get loginToYourAccount => 'Log in to Your Account';

  @override
  String get password => 'Password';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get dashboard => 'Dashboard';

  @override
  String get document => 'Document';

  @override
  String get task => 'Tasks';

  @override
  String get transaction => 'Transactions';

  @override
  String get unknown => 'Bilinmiyor';

  @override
  String get requiredText => 'This field is required';

  @override
  String atLeastLenghtText(int desiredLenght) =>
      'Please enter at least $desiredLenght char';

  @override
  String get invalidCreditCardCvvText => 'Please enter valid Credit Card CVV';

  @override
  String get invalidCreditCardDateText => 'Please enter valid Credit Card Date';

  @override
  String get invalidCreditCardNumberText =>
      'Please enter valid Credit Card Number';

  @override
  String get invalidMailText => 'Please enter valid E-mail';

  @override
  String get invalidNameText => 'Please enter valid Name';
  
  @override
  String get logout => 'Logout';
  
  @override
  String get succesfullyLoggedIn => 'Succesfully logged in.';
  
  @override
  String get succesfullyLoggedOut => 'Succesfully logged out.';
}
