// ignore_for_file: sort_constructors_first

enum SubRouteEnums {
  orderHistory(
    '/order-history',
    'orderHistoryScreen',
  ),
  transactionHistory(
    '/transaction-history',
    'transactionScreen',
  ),
    manageAccount(
    '/manage-account',
    'manageAccountScreen',
  ),
  productDetail(
    '/product',
    'productDetailScreen',
  ),
  loginSubScreen(
    '/loginSub',
    'loginSubScreen',
  ),
  ;

  /// Gets the path value for [SubRouteEnums] enum.
  final String path;

  /// Gets the path name for [SubRouteEnums] enum.
  final String name;
  const SubRouteEnums(this.path, this.name);
}
