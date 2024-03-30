import 'package:bb_example_app/features/landing/splash_screen/splash_screen.dart';
import 'package:bb_example_app/product/navigation/modules/initial_route/initial_route_enums.dart';
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
