import 'package:flutter/widgets.dart';
import 'package:go_router/go_router.dart';

///Abstract class that will used for [GoRouter]
abstract class AbstractRoutingManager {
  

  ///Context to use whole app from NavigatorKey.
  BuildContext? get context;

  ///GoRouter instance
  GoRouter get router;

  ///Router Delegate
  RouterDelegate<Object> get routerDelegate;

  ///RouteInformationParser
  RouteInformationParser<Object> get routeInformationParser;
}
