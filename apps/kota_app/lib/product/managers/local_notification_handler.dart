import 'package:flutter/material.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:universal_io/io.dart'; // Platform kontrolü için

/// Class that handles local notifications
class LocalNotificationHandler {
  // --- Singleton Setup ---
  static LocalNotificationHandler? _instance;
  static FlutterLocalNotificationsPlugin? _pluginInstance;

  // Özel constructor
  LocalNotificationHandler._();

  /// Singleton instance getter
  static LocalNotificationHandler get instance {
    _instance ??= LocalNotificationHandler._();
    return _instance!;
  }

  /// Plugin instance getter (initialize çağrıldıktan sonra kullanılabilir)
  FlutterLocalNotificationsPlugin get plugin {
    if (_pluginInstance == null) {
      throw Exception(
          'LocalNotificationHandler must be initialized before accessing the plugin. Call LocalNotificationHandler.instance.initialize() first.');
    }
    return _pluginInstance!;
  }
  // --- End Singleton Setup ---

  /// Current notification Id (opsiyonel, basitlik için kaldırılabilir veya state management ile yönetilebilir)
  int _notificationIdCounter = 0;

  /// Initializes the notification plugin. Must be called once before using notifications,
  /// typically in main.dart or a splash screen.
  Future<void> initialize() async {
    // Zaten başlatıldıysa tekrar başlatma
    if (_pluginInstance != null) {
      debugPrint('LocalNotificationHandler already initialized.');
      return;
    }

    _pluginInstance = FlutterLocalNotificationsPlugin();

    // --- Android Initialization ---
    // 'app_icon' adında bir drawable kaynağınızın olduğundan emin olun:
    // android/app/src/main/res/drawable/app_icon.png (veya diğer formatlar)
    const AndroidInitializationSettings initializationSettingsAndroid =
        AndroidInitializationSettings('app_icon');

    // --- Darwin (iOS/macOS) Initialization ---
    final DarwinInitializationSettings initializationSettingsDarwin =
        DarwinInitializationSettings(
      requestAlertPermission: true, // Uygulama açıkken uyarı gösterilsin mi?
      requestBadgePermission: true, // Badge (bildirim sayısı) güncellensin mi?
      requestSoundPermission: true, // Ses çalınsın mı?
      // onDidReceiveLocalNotification parametresi KALDIRILDI.
      // Aşağıdaki izin isteme ile birleştirildi veya NotificationDetails içinde yönetiliyor.

      // İsteğe bağlı: Bildirim tıklandığında çalışacak eski iOS < 10 versiyonları için callback
      // onDidReceiveLocalNotification: onDidReceiveLocalNotification // Bu artık gerekli değil ve kaldırıldı.
    );

    // --- Platform Genel Initialization Settings ---
    final InitializationSettings initializationSettings = InitializationSettings(
      android: initializationSettingsAndroid,
      iOS: initializationSettingsDarwin,
      macOS: initializationSettingsDarwin, // macOS desteği de ekleyebiliriz
    );

    // --- Plugin'i Başlat ---
    await _pluginInstance!.initialize(
      initializationSettings,
      // Bildirime tıklandığında tetiklenir (Uygulama açık, kapalı veya arkaplanda)
      onDidReceiveNotificationResponse: _onTapNotification,
      // Uygulama arkaplanda iken bildirimle ilişkili bir eyleme tıklandığında (nadiren kullanılır)
      // onDidReceiveBackgroundNotificationResponse: notificationTapBackground,
    );

    // --- iOS için Ek İzin İsteme (initialize içindeki request'ler yetmeyebilir veya
    // kullanıcıya daha belirgin bir zamanda sormak isteyebilirsiniz) ---
    // Bu genellikle initialize'dan ÖNCE yapılır ama burada da bırakılabilir.
    if (Platform.isIOS) {
      await _pluginInstance!
          .resolvePlatformSpecificImplementation<
              IOSFlutterLocalNotificationsPlugin>()
          ?.requestPermissions(
            alert: true,
            badge: true,
            sound: true,
          );
    }
     // --- Android 13+ için Ek İzin İsteme ---
     // Android 13 (API 33) ve üzeri için bildirim iznini ayrıca istemeniz GEREKİR.
     // Bu genellikle permission_handler gibi bir paketle yapılır.
     // Örnek (permission_handler paketi eklenmiş varsayılır):
     /*
     if (Platform.isAndroid) {
       final AndroidFlutterLocalNotificationsPlugin? androidImplementation =
           _pluginInstance!.resolvePlatformSpecificImplementation<
               AndroidFlutterLocalNotificationsPlugin>();
       final bool? granted = await androidImplementation?.requestNotificationsPermission();
       debugPrint('Android Notification Permission Granted: $granted');
       // Veya permission_handler ile:
       // var status = await Permission.notification.request();
       // if (status.isGranted) { ... }
     }
     */

    debugPrint('LocalNotificationHandler initialized successfully.');
  }

  // Callback: Bildirime tıklandığında çalışır
  // Statik veya üst düzey bir fonksiyon olması önerilir eğer main isolate dışında çalışması gerekiyorsa
  // ama burada sınıf içinde de tutulabilir.
  @pragma('vm:entry-point')
  static void _onTapNotification(NotificationResponse notificationResponse) {
    // Payload'ı işleyin, yönlendirme yapın vb.
    debugPrint('Notification Tapped:');
    debugPrint('  ID: ${notificationResponse.id}');
    debugPrint('  Action ID: ${notificationResponse.actionId}');
    debugPrint('  Input: ${notificationResponse.input}'); // Yanıt içeren bildirimler için
    debugPrint('  Payload: ${notificationResponse.payload}');
    debugPrint('  Notification ID: ${notificationResponse.notificationResponseType}');

    if (notificationResponse.payload != null && notificationResponse.payload!.isNotEmpty) {
      // Örneğin payload'a göre belirli bir sayfaya yönlendirme
      // navigatorKey.currentState?.pushNamed('/details', arguments: notificationResponse.payload);
    }
  }

  // Bu metod artık kullanılmıyor ve kaldırıldı.
  // Future<void> _onDidReceiveLocalNotification(
  //   int id,
  //   String? title,
  //   String? body,
  //   String? payload,
  // ) async {
  //   debugPrint('onDidReceiveLocalNotification payload: $payload');
  // }

  /// Method to call for showing notification
  Future<void> showNotification({
      required String title, // Başlık zorunlu olmalı
      required String body, // İçerik zorunlu olmalı
      String? payload, // İsteğe bağlı veri
      }) async {
    // Plugin'in başlatıldığından emin olun
    if (_pluginInstance == null) {
      debugPrint(
          'Error: Notification plugin not initialized. Call initialize() first.');
      return;
    }

    _notificationIdCounter++; // Her seferinde farklı ID

    // --- Android Bildirim Detayları ---
     AndroidNotificationDetails androidDetails = AndroidNotificationDetails(
      'your_channel_id', // Benzersiz kanal ID'si
      'Your Channel Name', // Kullanıcıya görünecek kanal adı
      channelDescription: 'Your channel description', // Kanal açıklaması
      importance: Importance.max, // Önem seviyesi (Max, High, Default, Low, Min)
      priority: Priority.high, // Öncelik (Android 7.1 ve altı için)
      ticker: 'ticker', // Bildirim geldiğinde durum çubuğunda kısa süreli görünen metin
      visibility: NotificationVisibility.public, // Kilit ekranında görünürlük
      // sound: RawResourceAndroidNotificationSound('notification_sound'), // Özel ses dosyası için (android/app/src/main/res/raw/notification_sound.mp3)
      // largeIcon: DrawableResourceAndroidBitmap('app_icon'), // Büyük ikon
       styleInformation: BigTextStyleInformation(body), // Uzun metinler için
    );

    // --- Darwin (iOS/macOS) Bildirim Detayları ---
    const DarwinNotificationDetails darwinDetails = DarwinNotificationDetails(
      presentAlert: true, // Uygulama ön plandayken uyarı gösterilsin mi?
      presentBadge: true, // Uygulama ön plandayken badge güncellensin mi?
      presentSound: true, // Uygulama ön plandayken ses çalınsın mı?
      // sound: 'default', // Özel ses için 'custom_sound.caf' gibi
      // badgeNumber: 1, // Belirli bir badge sayısı ayarlamak için
      interruptionLevel: InterruptionLevel.active, // iOS 15+ Kesinti seviyesi
    );

    // --- Genel Bildirim Detayları ---
    NotificationDetails notificationDetails = NotificationDetails(
      android: androidDetails,
      iOS: darwinDetails,
      macOS: darwinDetails, // macOS için de aynı ayarları kullanabiliriz
    );

    // --- Bildirimi Göster ---
    try {
      await plugin.show(
        _notificationIdCounter, // Benzersiz ID
        title,
        body,
        notificationDetails,
        payload: payload ?? 'item $_notificationIdCounter', // Tıklama anında alınacak veri
      );
      debugPrint('Notification shown with ID: $_notificationIdCounter');
    } catch (e) {
      debugPrint('Error showing notification: $e');
    }
  }

  // Bildirimleri iptal etmek için metodlar (isteğe bağlı)
  Future<void> cancelNotification(int id) async {
     if (_pluginInstance == null) return;
     await plugin.cancel(id);
     debugPrint('Cancelled notification with ID: $id');
  }

  Future<void> cancelAllNotifications() async {
    if (_pluginInstance == null) return;
    await plugin.cancelAll();
    debugPrint('Cancelled all notifications.');
  }
}