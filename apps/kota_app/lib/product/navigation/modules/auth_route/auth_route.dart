import 'package:bb_example_app/features/auth/login_screen/login_screen.dart';
import 'package:bb_example_app/features/auth/register_screen/register_screen.dart';
import 'package:bb_example_app/product/navigation/modules/auth_route/auth_route_enums.dart';
import 'package:bb_example_app/product/navigation/routing_manager.dart';
import 'package:go_router/go_router.dart';

/// Route Class for Auth Routes
class AuthRoute {
  AuthRoute._();

  static final route = ShellRoute(
    navigatorKey: RoutingManager.authKey,
    pageBuilder: (context, state, child) {
      return NoTransitionPage(
        child: child,
      );
    },
    routes: [
      GoRoute(
        name: AuthRouteScreens.loginScreen.name,
        path: AuthRouteScreens.loginScreen.path,
        pageBuilder: (context, state) {
          return const NoTransitionPage(
            child: LoginScreen(),
          );
        },
      ),
      GoRoute(
        name: AuthRouteScreens.registerScreen.name,
        path: AuthRouteScreens.registerScreen.path,
        pageBuilder: (context, state) {
          return const NoTransitionPage(
            child: RegisterScreen(),
          );
        },
      ),
    ],
  );
}
