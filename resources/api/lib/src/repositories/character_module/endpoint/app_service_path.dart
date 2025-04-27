// ignore_for_file: sort_constructors_first

///Enum that represnt all character endpoints
enum AppServicePath {
  /// /api/character

  /// no need claim
  login('api/Auth/Login'),

  /// no need claim
  register('api/Auth/Register'),

  /// forgot password endpoints
  sendForgotPasswordCode('api/Auth/ForgotPassword'),
  verifyForgotPasswordCode('api/Auth/VerifyForgotPasswordCode'),
  resetPassword('api/Auth/ResetPassword'),

  /// claim:
  transactionHistory('/api/CariHesaps/Hareket'),

  /// no need claim
  orderHistory('api/AlinanSiparises/byCurrencyId'),

  /// no need claim
  orderHistoryDetail('api/AlinanSiparises'),

  /// no need claim
  createOrder('api/AlinanSiparises'),

  /// no need claim
  currentUser('/api/Auth/User'),

  productGroupList('/api/ProductCodeGroups'),

  productCategoryList('/api/ProductCategories'),

  productGroupItem('/api/ProductCodeGroups/getByBarcode'),

  productVariant('/api/ProductVariants/getByCode'),

  userOperationClaims('api/UserOperationClaims/byUserId'),

  currentAccounts('api/CariHesaps'),
  currentAccountsWithBalance('api/CariHesaps/WithBalance'),

  saleInvoice('api/SatisFaturas'),

  /// Active orders by current account id
  activeOrders('api/AlinanSiparisBilgileris/getallbycurrentaccountid'),

  ;

  ///String value of the enum.
  final String value;

  const AppServicePath(this.value);

  String withPath(String value) {
    return '${this.value}/$value';
  }
}
