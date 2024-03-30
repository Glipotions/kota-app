import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';

///You can manage firebase dynamic links through this class
class FirebaseDeeplinkService {
  FirebaseDeeplinkService._();
  static FirebaseDeeplinkService? _instance;

  /// FirebaseDeeplinkService instance
  FirebaseDeeplinkService get instance {
    _instance ??= FirebaseDeeplinkService._();
    return _instance!;
  }

  /// This method return current link that triggers the app.
  /// Null if there is nothing.
  Future<PendingDynamicLinkData?> getAndListenToDynamicLink() async {
    try {
      final initialLink = await FirebaseDynamicLinks.instance.getInitialLink();
      return initialLink;
    } catch (e) {
      return null;
    }
  }
}
