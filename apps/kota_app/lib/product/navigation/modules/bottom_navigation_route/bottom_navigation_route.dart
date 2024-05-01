import 'package:go_router/go_router.dart';
import 'package:kota_app/features/index.dart';
import 'package:kota_app/features/main/all_products_screen/all_products_screen.dart';
import 'package:kota_app/features/main/cart_screen/view/cart.dart';
import 'package:kota_app/features/main/profile_screen/profile_screen.dart';
import 'package:kota_app/product/navigation/modules/bottom_navigation_route/bottom_navigation_route_enums.dart';
import 'package:kota_app/product/navigation/routing_manager.dart';

/// Route Class for Drawer Routes
class BottomNavigationRoute {
  BottomNavigationRoute._();

  /// Bottom Navigation Router
  static final route = ShellRoute(
    navigatorKey: RoutingManager.shellKey,
    pageBuilder: (context, state, child) {
      return NoTransitionPage(
        child: BottomNavigationBarScreen(
          child: child,
        ),
      );
    },
    routes: [
      GoRoute(
        name: BottomNavigationRouteEnum.cartScreen.name,
        path: BottomNavigationRouteEnum.cartScreen.path,
        parentNavigatorKey: RoutingManager.shellKey,
        pageBuilder: (context, state) {
          return const NoTransitionPage(
            child: Cart(),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: RoutingManager.shellKey,
        name: BottomNavigationRouteEnum.allProductsScreen.name,
        path: BottomNavigationRouteEnum.allProductsScreen.path,
        pageBuilder: (context, state) {
          return const NoTransitionPage(
            child: AllProductsScreen(),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: RoutingManager.shellKey,
        name: BottomNavigationRouteEnum.profileScreen.name,
        path: BottomNavigationRouteEnum.profileScreen.path,
        pageBuilder: (context, state) {
          return const NoTransitionPage(
            child: ProfileScreen(),
          );
        },
      ),
    ],
  );
}
