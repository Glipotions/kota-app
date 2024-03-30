// ignore_for_file: sort_constructors_first

enum DrawerRouteScreens {
  dashboardScreen(
    '/dashboard',
    'dashboardScreen',
  ),
  transactionScreen(
    '/transaction',
    'transactionScreen',
  ),
  taskScreen(
    '/task',
    'taskScreen',
  ),
  documentScreen(
    '/document',
    'documentScreen',
  );

  /// Gets the path value for [DrawerRouteScreens] enum.
  final String path;

  /// Gets the path name for [DrawerRouteScreens] enum.
  final String name;
  const DrawerRouteScreens(this.path, this.name);
}
