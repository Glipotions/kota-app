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
  productDetail(
    '/product',
    'productDetailScreen',
  ),

  ;

  /// Gets the path value for [SubRouteEnums] enum.
  final String path;

  /// Gets the path name for [SubRouteEnums] enum.
  final String name;
  const SubRouteEnums(this.path, this.name);
}
