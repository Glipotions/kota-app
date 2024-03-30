// ignore_for_file: sort_constructors_first

///Enum that represnt all character endpoints
enum AppServicePath {
  /// /api/character
  login('api/Auth/Login'),

  register('api/Auth/Register'),

  transactionHistory('/api/CariHesaps/Hareket'),

  orderHistory('api/AlinanSiparises/byCurrencyId'),

  balance('api/CariHesaps'),

  createOrder('api/AlinanSiparises'),

  currentUser('/api/Auth/User'),

  getProductDetail('/api/ProductVariants/getByCode'),

  productGroupList('/api/ProductCodeGroups'),

  productVariant('/api/ProductVariants/getByCode'),

  productGroupItem('/api/ProductCodeGroups/getByBarcode'),


  ;

  ///String value of the enum.
  final String value;

  const AppServicePath(this.value);

  String withPath(String value) {
    return '${this.value}/$value';
  }
}
