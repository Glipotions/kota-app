import 'dart:async';
import 'package:firebase_messaging/firebase_messaging.dart';

///You can manage firebase messaging through this class
class FirebaseMessagingService {
  FirebaseMessagingService._init();

  ///Instace for Firebase Messaging service that comes from Firebase package
  late final FirebaseMessaging messaging;

  ///Function that will triggered when notification received
  late final void Function(String?, String?) onShowNotication;

  static final FirebaseMessagingService _instance =
      FirebaseMessagingService._init();

  ///Instace for Firebase Messaging service class that we created.
  static FirebaseMessagingService get instance => _instance;

  ///This method needs to be called when app is starting.
  ///Otherwise it throws error when using
  static Future<void> messagingInit({
    required void Function(String?, String?) showNotification,
  }) async {
    instance.messaging = FirebaseMessaging.instance;
    instance.onShowNotication = showNotification;
  }

  ///This method needs to be called when app is starting.
  ///Otherwise it throws error when using
  Future<void> listenToNotification() async {
    await messaging.requestPermission();
    FirebaseMessaging.onMessage.listen(
      (message) => instance.onShowNotication(
        message.notification?.title,
        message.notification?.body,
      ),
    );
    FirebaseMessaging.onMessageOpenedApp.listen((RemoteMessage event) {});
    FirebaseMessaging.onBackgroundMessage(
      (message) async => instance.onShowNotication(
        message.notification?.title,
        message.notification?.body,
      ),
    );
  }

  ///This method return FCM token for current device.
  Future<String?> getToken() async {
    try {
      final token = await messaging.getToken();
      return token;
    } catch (e) {
      return null;
    }
  }
}
