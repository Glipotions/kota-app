import 'package:flutter/material.dart';

/// Class to keep Scren related Sizes
class SizeConfig {
  static double _statusBarHeight = 0;
  static double _screenWidth = 0;
  static double _screenHeight = 0;

  static MediaQueryData _mediaQueryData(BuildContext context) =>
      MediaQueryData.fromView(View.of(context));

  /// Returns screen width.
  static double screenWidth(BuildContext context) =>
      _screenWidth = _mediaQueryData(context).size.width == 0
          ? _screenWidth
          : _mediaQueryData(context).size.width;

  /// Returns screen height.
  static double screenHeight(BuildContext context) =>
      _screenHeight = _mediaQueryData(context).size.height == 0
          ? _screenHeight
          : _mediaQueryData(context).size.height;

  /// Returns the width of one percentage point of the screen width.
  static double blockSizeHorizontal(BuildContext context) =>
      screenWidth(context) / 100;

  /// Returns the height of one percentage point of the screen height.
  static double blockSizeVertical(BuildContext context) =>
      screenHeight(context) / 100;

  /// Calculates the horizontal padding from the safe area.
  static double _safeAreaHorizontal(BuildContext context) =>
      _mediaQueryData(context).padding.left +
      _mediaQueryData(context).padding.right;

  /// Calculates the vertical padding from the safe area.
  static double _safeAreaVertical(BuildContext context) =>
      _mediaQueryData(context).padding.top +
      _mediaQueryData(context).padding.bottom;

  /// Returns the width of one percentage point of the screen width
  /// excluding safe area padding.
  static double safeBlockHorizontal(BuildContext context) =>
      (screenWidth(context) - _safeAreaHorizontal(context)) / 100;

  /// Returns the height of one percentage point of the screen height,
  /// excluding safe area padding.
  static double safeBlockVertical(BuildContext context) =>
      (screenHeight(context) - _safeAreaVertical(context)) / 100;

  /// Returns the height of the device's status bar.
  static double statusBarHeight(BuildContext context) =>
      _statusBarHeight = _mediaQueryData(context).padding.top != 0
          ? _mediaQueryData(context).padding.top
          : _statusBarHeight;

  /// Returns the padding of the safe area.
  static EdgeInsets safeAreaPadding(BuildContext context) =>
      _mediaQueryData(context).padding;

  /// Returns the device's pixel ratio.
  static double devicePixelRatio(BuildContext context) =>
      _mediaQueryData(context).devicePixelRatio;

  /// Returns the standard height of an app bar.
  static double get appBarHeight => kToolbarHeight;

  /// Returns the height of the screen, excluding the status bar.
  static double screenHeightTopSafeArea(BuildContext context) =>
      screenHeight(context) - statusBarHeight(context);
}
