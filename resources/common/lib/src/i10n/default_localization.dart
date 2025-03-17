import 'package:common/src/i10n/lan/en.dart';
import 'package:common/src/i10n/lan/ru.dart';
import 'package:common/src/i10n/lan/tr.dart';
import 'package:common/src/i10n/lan/ar.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart' show Locale;

/// Default Locale ayarlarımız
const Locale kDefaultLocal = Locale('tr');

/// Ugulamanın desteklediği diler
Map<String, AppLocalizationLabel> supportedLocalization = {
  'tr': TrLocalization(),
  'en': EnLocalization(),
  'ru': RuLocalization(),
  'ar': ArLocalization(),
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

  ///Currency
  String get currency;

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

  // Account Management
  String get accountSettings;
  String get language;
  String get selectLanguage;
  String get username;
  String get fullName;
  String get email;
  String get darkMode;
  String get deleteAccount;
  String get deleteAccountSubtitle;
  String get deleteAccountDialogTitle;
  String get deleteAccountDialogMessage;
  String get deleteAccountDescription;
  String get deleteAccountConfirmation;
  String get deleteAccountWarning;
  String get cancel;
  String get delete;

  // Products Screen
  String get products;
  String get filter;
  String get clearFilters;
  String get searchTermRequired;
  String get noProductsFound;
  String get searchAndSelect;
  String get accountInfo;
  String get preferences;
  String get accountManagement;

  // Cart Screen
  String get cart;
  String get clearCart;
  String get clearCartConfirmation;
  String get clear;
  String get totalAmount;
  String get orderNote;
  String get addOrderNote;
  String get completeOrder;
  String get updateOrder;
  String get emptyCartMessage;
  String get removeFromCart;
  String get addToCart;
  String get updateCart;
  String get inStock;
  String get outOfStock;
  String get selectColorAndSize;
  String get enterValidQuantity;
  String get productAddedToCart;

  // Profile Screen
  String get profile;
  String get balance;
  String get pastOrders;
  String get pastOrdersDescription;
  String get transactions;
  String get transactionsDescription;
  String get support;
  String get supportDescription;
  String get userAccountInfo;
  String get userAccountInfoDescription;
  String get signOut;
  String get signOutDescription;

  // Order History Screen
  String get orderHistory;
  String get noOrders;
  String get subAccount;
  String get orderNumber;
  String get deleteOrder;
  String get deleteOrderConfirmation;
  String get details;
  String get edit;
  String get downloadPdf;
  String get waiting;
  String get completed;
  String get preparing;

  // Transaction History Screen
  String get transactionHistory;
  String get currentBalance;
  String get income;
  String get expense;
  String get searchTransactions;
  String get noTransactions;

  // Product Detail Screen
  String get productDetail;
  String get productsInCart;
  String get piece;
  String get removeProduct;
  String get removeProductConfirm;
  String get remove;
  String get colorSelection;
  String get sizeSelection;
  String get noProductInCart;

  // Bottom Navigation Bar
  String get home;

  // Order Confirmation Dialog
  String get orderConfirmationTitle;
  String orderConfirmationMessage(String companyName);
  String get confirm;

  ///Order successfully deleted
  String get orderDeletedSuccessfully;

  ///Order successfully updated
  String get orderUpdatedSuccessfully;

  ///Error updating order
  String get orderUpdateError;

  ///Order successfully created
  String get orderCreatedSuccessfully;

  ///Error creating order
  String get orderCreateError;

  // PDF Table Headers
  String get productName;
  String get productCode;
  String get size;
  String get color;
  String get quantity;
  String get price;
  String get total;

  // Order Detail
  String get orderDetail;
  String get noOrderDetail;

  // Filter
  String get category;
  String get subCategories;
  String get all;
  String get priceRange;
  String get minPrice;
  String get maxPrice;
  String get applyFilter;
  String get clearFilter;

  // Sorting
  String get sorting;
  String get priceAscending;
  String get priceDescending;
  String get nameAscending;
  String get nameDescending;

  // PDF Order Detail
  String get orderSummary;
  String get description;
  String get quantityTotal;
  String get orderTotalPrice;
  String get unitPrice;
  String get amount;

  // Login Messages
  String get accountNotApproved;
  String get loginError;

  // Transaction PDF Report
  String get warning;
  String get noDataToReport;
  String get date;
  String get receiptNo;
  String get receiptType;
  String get debit;
  String get credit;
  String get foreignDebit;
  String get foreignCredit;
  String get foreignBalance;
  String get current;
  String get period;

  // Cart PDF
  String get cartProducts;
  String get page;
  String get totalQuantity;
  String get code;
  
  // Forgot Password
  /// Verification code has been sent to your email
  String get verificationCodeSent;
  
  /// Something went wrong. Please try again.
  String get somethingWentWrong;
  
  /// Code has been verified successfully
  String get codeVerified;
  
  /// Invalid verification code
  String get invalidCode;
  
  /// Passwords do not match
  String get passwordsDoNotMatch;
  
  /// Password has been reset successfully
  String get passwordResetSuccess;
  
  /// Verification code has been resent to your email
  String get verificationCodeResent;
  
  /// Email is required
  String get emailRequired;
  
  /// Forgot Password
  String get forgotPassword;
  
  /// Reset Password
  String get resetPassword;
  
  /// Verify Code
  String get verifyCode;
  
  /// Enter the verification code sent to your email
  String get enterVerificationCode;
  
  /// Enter your new password
  String get enterNewPassword;
  
  /// Confirm your new password
  String get confirmNewPassword;
  
  /// Resend Code
  String get resendCode;

  // Invoice PDF
  /// Sales Invoice
  String get salesInvoice;
  
  /// Invoice Details
  String get invoiceDetails;
  
  /// Date
  String get invoiceDate;
  
  /// Code (for invoice)
  String get invoiceProductCode;
  
  /// Product Name (for invoice)
  String get invoiceProductName;
  
  /// Quantity (for invoice)
  String get invoiceQuantity;
  
  /// Unit Price (for invoice)
  String get unitPriceInvoice;
  
  /// Total (for invoice)
  String get totalInvoice;
  
  /// Subtotal
  String get subtotal;
  
  /// VAT Rate
  String get vatRate;
  
  /// VAT Total
  String get vatTotal;
  
  /// Grand Total
  String get grandTotal;
  
  /// This invoice was generated electronically
  String get electronicInvoiceNote;
}
