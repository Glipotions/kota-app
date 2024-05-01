// ignore_for_file: sort_constructors_first

enum BottomNavigationRouteEnum {
  allProductsScreen(
    '/all-products',
    'allProductsScreen',
  ),
  cartScreen(
    '/cart',
    'cartScreen',
  ),
  profileScreen(
    '/profile',
    'profileScreen',
  );

  /// Gets the path value for [BottomNavigationRouteEnum] enum.
  final String path;

  /// Gets the path name for [BottomNavigationRouteEnum] enum.
  final String name;
  const BottomNavigationRouteEnum(this.path, this.name);
}
