import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:kota_app/features/auth/forgot_password_screen/forgot_password_screen.dart';
import 'package:kota_app/features/auth/login_screen/login_screen.dart';
import 'package:kota_app/features/auth/register_screen/register_screen.dart';
import 'package:kota_app/product/navigation/modules/auth_route/auth_route_enums.dart';

/// Route Class for Auth Routes
class AuthRoute {
  AuthRoute._();

  // Removed ShellRoute wrapper
  static final List<RouteBase> routes = [
    GoRoute(
      // parentNavigatorKey: RoutingManager.parentKey, // Removed explicit key
      name: AuthRouteScreens.loginScreen.name,
      path: AuthRouteScreens.loginScreen.path,
      pageBuilder: (context, state) {
        return const MaterialPage(
          child: LoginScreen(),
        );
      },
    ),
    GoRoute(
      // parentNavigatorKey: RoutingManager.parentKey, // Removed explicit key
      name: AuthRouteScreens.registerScreen.name,
      path: AuthRouteScreens.registerScreen.path,
      pageBuilder: (context, state) {
        return const MaterialPage(
          child: RegisterScreen(),
        );
      },
    ),
    GoRoute(
      // parentNavigatorKey: RoutingManager.parentKey, // Removed explicit key
      name: AuthRouteScreens.forgotPasswordScreen.name,
      path: AuthRouteScreens.forgotPasswordScreen.path,
      pageBuilder: (context, state) {
        return const MaterialPage(
          child: ForgotPasswordScreen(),
        );
      },
    ),
  ];
}
