import 'package:flutter/material.dart' show Widget;
import 'package:overlay_kit/overlay_kit.dart';



/// A utility class for managing loading progress overlays.
///
/// Use this class to start and stop loading progress overlays
/// with customizable loading widgets.
///
/// Example:
/// ```dart
/// Initialize the default loading widget
/// await LoadingProgress.loadingProgressInit(loadingWidget: MyLoadingWidget());
///
/// // Start loading progress overlay
/// LoadingProgress.start();
///
/// // Stop loading progress overlay
/// LoadingProgress.stop();
/// ```
class LoadingProgress {
  /// Starts a loading progress overlay.
  ///
  /// Parameters:
  /// - `widget`: The loading widget to display. If not provided, the default
  ///  loading widget will be used.
  LoadingProgress.start({Widget? widget}) {
    OverlayLoadingProgress.start(
      widget: widget ?? instance._defaultWidget,
    );
  }

  /// Stops the currently active loading progress overlay.
  LoadingProgress.stop() {
    OverlayLoadingProgress.stop();
  }

  /// Private constructor for initializing the singleton instance.
  LoadingProgress._init();

  /// The default loading widget used if no specific widget is provided.
  late Widget _defaultWidget;

  /// The singleton instance of the LoadingProgress class.
  static final LoadingProgress _instance = LoadingProgress._init();

  /// Gets the singleton instance of the LoadingProgress class.
  static LoadingProgress get instance => _instance;

  /// Initializes the default loading widget for the LoadingProgress class.
  ///
  /// Parameters:
  /// - `loadingWidget`: The default loading widget to be used.
  ///
  /// Returns a Future that completes when the default loading widget is set.
  static Future<void> loadingProgressInit({
    required Widget loadingWidget,
  }) async {
    instance._defaultWidget = loadingWidget;
  }
}
