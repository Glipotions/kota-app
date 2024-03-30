import 'package:firebase_core/firebase_core.dart';

///You can manage FirebaseCore operations through this class
class FirebaseCore {
  ///Initialize the current firebase within the app.
  Future<void> initialize() async {
    await Firebase.initializeApp();
  }
}
