import 'package:bb_example_admin_panel/features/index.dart';
import 'package:bb_example_admin_panel/product/navigation/modules/initial_route/initial_route_enums.dart';

import 'package:go_router/go_router.dart';

/// Route Class for Initial Route
class InitialRoute {
  InitialRoute._();

  /// Initial Router
  static final route = GoRoute(
    name: InitialRouteScreens.splashScreen.name,
    path: InitialRouteScreens.splashScreen.path,
    builder: (context, state) => const SplashScreen(),
  );
}
