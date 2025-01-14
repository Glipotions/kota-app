// ignore_for_file: sort_constructors_first

///Enum that represnt all character endpoints
enum AppServicePath {
  /// /api/character

  /// no need claim
  login('api/Auth/Login'),

  /// no need claim
  register('api/Auth/Register'),

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

  ;

  ///String value of the enum.
  final String value;

  const AppServicePath(this.value);

  String withPath(String value) {
    return '${this.value}/$value';
  }
}
