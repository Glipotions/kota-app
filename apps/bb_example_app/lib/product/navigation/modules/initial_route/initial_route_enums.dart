// ignore_for_file: sort_constructors_first

enum InitialRouteScreens {
  splashScreen(
    '/',
    'splashScreen',
  );

  /// Gets the path value for [InitialRouteScreens] enum.
  final String path;

  /// Gets the path name for [InitialRouteScreens] enum.
  final String name;
  const InitialRouteScreens(this.path, this.name);
}
