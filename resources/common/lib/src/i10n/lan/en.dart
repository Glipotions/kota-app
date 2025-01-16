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
  String get succesfullyLoggedIn => 'Successfully logged in.';
  
  @override
  String get succesfullyLoggedOut => 'Succesfully logged out.';

  // Account Management
  @override
  String get accountSettings => 'Account Settings';
  @override
  String get language => 'Language';
  @override
  String get selectLanguage => 'Select Language';

  // Products Screen
  @override
  String get products => 'Products';
  @override
  String get filter => 'Filter';
  @override
  String get clearFilters => 'Clear Filters';
  @override
  String get searchTermRequired => 'Enter search term.';
  @override
  String get noProductsFound => 'No products found';
  @override
  String get searchAndSelect => 'Search and press enter...';
  @override
  String get accountInfo => 'Account Information';
  @override
  String get preferences => 'Preferences';
  @override
  String get accountManagement => 'Account Management';

  @override
  String get username => 'Username';
  @override
  String get fullName => 'Full Name';
  @override
  String get email => 'Email';
  @override
  String get darkMode => 'Dark Mode';
  @override
  String get deleteAccount => 'Delete Account';
  @override
  String get deleteAccountSubtitle => 'This action cannot be undone';
  @override
  String get deleteAccountDialogTitle => 'Delete Account Confirmation';
  @override
  String get deleteAccountDialogMessage => 'Are you sure you want to delete your account? This action cannot be undone.';
  @override
  String get cancel => 'Cancel';

  @override
  String get deleteAccountDescription => 'Are you sure you want to delete your account?';

  @override
  String get deleteAccountConfirmation => 'Delete Account';

  @override
  String get deleteAccountWarning => 'This action cannot be undone. All your data will be deleted.';

  @override
  String get delete => 'Delete';

  // Cart Screen
  @override
  String get cart => 'My Cart';
  @override
  String get clearCart => 'Clear Cart';
  @override
  String get clearCartConfirmation => 'Are you sure you want to remove all items from your cart?';
  @override
  String get clear => 'Clear';
  @override
  String get totalAmount => 'Total Amount:';
  @override
  String get orderNote => 'Order Note';
  @override
  String get addOrderNote => 'Add a note for your order...';
  @override
  String get completeOrder => 'Complete Order';
  @override
  String get updateOrder => 'Update Order';
  @override
  String get emptyCartMessage => 'No items in cart.\nAll items you add to cart will be listed here!';
  @override
  String get removeFromCart => 'Remove from Cart';
}
