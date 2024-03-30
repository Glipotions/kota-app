import 'package:flutter/widgets.dart';
import 'package:responsive_framework/responsive_framework.dart';

/// Custom responsive for project
/// [MOBILE] 0 - 450
/// [TABLET] 451 - 800
/// [DESKTOP] 801 - 1920
/// [4K] 1921 - double.infinity
/// [CustomResponsive.build(context, child)]
class CustomResponsive {
  /// Make to ui responsive
  Widget build({required BuildContext context,required Widget child}) {
    return ResponsiveBreakpoints.builder(
      child: child,
      breakpoints: [
        const Breakpoint(start: 0, end: 450, name: MOBILE),
        const Breakpoint(start: 451, end: 800, name: TABLET),
        const Breakpoint(start: 801, end: 1920, name: DESKTOP),
        const Breakpoint(start: 1921, end: double.infinity, name: '4K'),
      ],
    );
  }

  ///Returns if current dimension is mobile
  bool isMobile(BuildContext context) =>
      ResponsiveBreakpoints.of(context).isMobile;

  ///Returns if current dimension is mobile
  bool isTablet(BuildContext context) =>
      ResponsiveBreakpoints.of(context).isTablet;

  ///Returns if current dimension is mobile
  bool isDesktop(BuildContext context) =>
      ResponsiveBreakpoints.of(context).isDesktop;

  ///Returns if current dimension is mobile
  bool is4K(BuildContext context) =>
      ResponsiveBreakpoints.of(context).largerThan(DESKTOP);

}
