// ignore_for_file: sort_constructors_first

enum AuthRouteScreens {

  loginScreen(
    '/login',
    'loginScreen',
  );

  /// Gets the path value for [AuthRouteScreens] enum.
  final String path;

  /// Gets the path name for [AuthRouteScreens] enum.
  final String name;
  const AuthRouteScreens(this.path, this.name);
}
