import 'package:flutter/material.dart';
import 'package:overlay_kit/overlay_kit.dart';

/// Enumeration representing different types of toast messages.
enum ToastMessageType {
  /// Warning toast message type.
  warning,

  /// Error toast message type.
  error,

  /// Success toast message type.
  success,
}

/// Singleton class to manage and display toast messages.
class ToastMessage {


  /// Displays a toast message with the specified parameters.
  ///
  /// If a custom [widget] is not provided, the default widget for
  /// the specified [type] is used.
  /// The [duration] parameter controls how long the toast message
  /// will be displayed.
  
  ToastMessage.showToastMessage(
    {
      required String message,
    required ToastMessageType type, 
    Widget? widget,
    int? duration,
  }) {
    final defaultWidget = _instance._defaultWidget[type];
    if (defaultWidget == null) {
      throw Exception(
        '${type.name} is not initialized for toast message class.',
      );
    }

    final toastMessage = message;

    OverlayToastMessage.show(
      widget: widget ?? defaultWidget.copyWith(message: toastMessage),
      dismissAll: true,
      duration: Duration(seconds: duration ?? 4),
    );


  }

  
  ToastMessage._init();

  late Map<ToastMessageType, BaseMessageWidget> _defaultWidget;

  static final ToastMessage _instance = ToastMessage._init();

  /// Gets the singleton instance of [ToastMessage].
  static ToastMessage get instance => _instance;

  /// Initializes the default toast widgets for each message type.
  ///
  /// This method should be called before using [OverlayToastMessage.show].
  static Future<void> toastMessageInit({
    required Map<ToastMessageType, BaseMessageWidget> toastWidget,
  }) async {
    instance._defaultWidget = toastWidget;
  }

  
}

/// Abstract base class for toast message widgets.
abstract class BaseMessageWidget extends StatelessWidget {
  /// Constructs a [BaseMessageWidget] with an optional [message].
  const BaseMessageWidget({super.key, this.message});

  /// Message to display on toast
  final String? message;

  @override
  Widget build(BuildContext context);

  /// Creates a copy of this widget with an optional [message].
  BaseMessageWidget copyWith({String? message});
}

/// Extension methods for [BaseMessageWidget].
extension BaseMessageWidgetExtension on BaseMessageWidget {
  /// Creates a copy of this widget with the same properties,
  /// except for an optional [message].
  BaseMessageWidget copyWithDefault({String? message}) {
    return copyWith(message: message ?? this.message);
  }
}
