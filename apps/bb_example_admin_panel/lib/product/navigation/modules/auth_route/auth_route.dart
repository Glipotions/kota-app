import 'package:bb_example_admin_panel/features/auth/login_screen/login_screen.dart';
import 'package:bb_example_admin_panel/product/navigation/modules/auth_route/auth_route_enums.dart';
import 'package:bb_example_admin_panel/product/navigation/routing_manager.dart';
import 'package:go_router/go_router.dart';

/// Route Class for Auth Routes
class AuthRoute {
  AuthRoute._();

  static final route = ShellRoute(
    navigatorKey: RoutingManager.shellKey,
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
    ],
  );
}
