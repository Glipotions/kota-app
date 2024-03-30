import 'package:bb_example_admin_panel/features/index.dart';
import 'package:bb_example_admin_panel/product/navigation/modules/drawer_route/drawer_route_enums.dart';
import 'package:bb_example_admin_panel/product/navigation/routing_manager.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

/// Route Class for Drawer Routes
class DrawerRoute {
  DrawerRoute._();

  /// Bottom Navigation Router
  static final route = ShellRoute(
    navigatorKey: RoutingManager.shellKey,
    pageBuilder: (context, state, child) {
      return NoTransitionPage(
        child: MainScreen(
          child: child,
        ),
      );
    },
    routes: [
      GoRoute(
        name: DrawerRouteScreens.dashboardScreen.name,
        path: DrawerRouteScreens.dashboardScreen.path,
        parentNavigatorKey: RoutingManager.shellKey,
        pageBuilder: (context, state) {
          return const NoTransitionPage(
            child: DashboardScreen(),
          );
        },
      ),
      GoRoute(
        name: DrawerRouteScreens.transactionScreen.name,
        path: DrawerRouteScreens.transactionScreen.path,
        parentNavigatorKey: RoutingManager.shellKey,
        pageBuilder: (context, state) {
          return NoTransitionPage(
            child: Center(
              child: Text(AppLocalization.getLabels(context).transaction),
            ),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: RoutingManager.shellKey,
        name: DrawerRouteScreens.taskScreen.name,
        path: DrawerRouteScreens.taskScreen.path,
        pageBuilder: (context, state) {
          return NoTransitionPage(
            child: Center(child: Text(AppLocalization.getLabels(context).task)),
          );
        },
      ),
      GoRoute(
        parentNavigatorKey: RoutingManager.shellKey,
        name: DrawerRouteScreens.documentScreen.name,
        path: DrawerRouteScreens.documentScreen.path,
        pageBuilder: (context, state) {
          return NoTransitionPage(
            child: Center(
              child: Text(AppLocalization.getLabels(context).document),
            ),
          );
        },
      ),
    ],
  );
}
