import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:universal_io/io.dart';

/// Class that handles local notifications
class LocalNotificationHandler {
  /// Factory constructor to ensure a constant context for static initialization
  factory LocalNotificationHandler() {
    _instance ??= LocalNotificationHandler._init();
    return _instance!;
  }

  // Private constructor
  LocalNotificationHandler._init() {
    flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    if (Platform.isIOS) {
      flutterLocalNotificationsPlugin!
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
    _initializeOtherPlatform();
  }

  /// Instance for [FlutterLocalNotificationsPlugin] needs to be
  /// init before used
  late final FlutterLocalNotificationsPlugin? flutterLocalNotificationsPlugin;

  /// Current notificaiton Id
  int notificationId = 0;
  static LocalNotificationHandler? _instance;

  Future<void> _initializeOtherPlatform() async {
    final flutterLocalNotificationsPlugin = FlutterLocalNotificationsPlugin();
    final initializationSettingsDarwin = DarwinInitializationSettings(
      onDidReceiveLocalNotification: _onDidReceiveLocalNotification,
    );
    final initializationSettings = InitializationSettings(
      android: const AndroidInitializationSettings('app_icon'),
      iOS: initializationSettingsDarwin,
    );
    await flutterLocalNotificationsPlugin.initialize(
      initializationSettings,
      onDidReceiveNotificationResponse: _onTapNotification,
    );
  }

  Future<void> _onTapNotification(NotificationResponse? payload) async {
    debugPrint('selectNotification payload: $payload');
  }

  Future<void> _onDidReceiveLocalNotification(
    int id,
    String? title,
    String? body,
    String? payload,
  ) async {
    debugPrint('onDidReceiveLocalNotification payload: $payload');
  }

  /// Method to call for showing notification
  Future<void> showNotification({String? title, String? body}) async {
    if (title == null) return;
    notificationId++;
    await flutterLocalNotificationsPlugin!.show(
      notificationId,
      title,
      body,
      const NotificationDetails(
        android: AndroidNotificationDetails(
          'general',
          'General',
          channelDescription: 'General',
          importance: Importance.max,
          priority: Priority.high,
          ticker: 'ticker',
          visibility: NotificationVisibility.public,
        ),
        iOS: DarwinNotificationDetails(
          presentAlert: true,
          presentBadge: true,
          presentSound: true,
          interruptionLevel: InterruptionLevel.active,
          sound: 'default',
        ),
      ),
      payload: 'item $notificationId',
    );
  }
}
