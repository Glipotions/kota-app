// ignore_for_file: use_setters_to_change_properties, 
// ignore_for_file: avoid_positional_boolean_parameters

import 'package:api/api.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:kota_app/product/base/controller/base_controller.dart';
import 'package:kota_app/product/managers/session_handler.dart';

class ManageAccountController extends BaseControllerInterface {
  ManageAccountController();

  @override
  SessionHandler get sessionHandler => SessionHandler.instance;

  final Rx<User> _user =
      Rx(User());

  User get user => _user.value;
  set user(User value) => _user.value = value;
  // Dil ve tema için Rx değişkenleri
  final RxString currentLanguage = 'English'.obs;
  final RxBool isDarkMode = false.obs;

  // Kullanıcı dili değiştirme
  void setLanguage(String newLanguage) {
    currentLanguage.value = newLanguage;
    // Burada dil ayarlarını uygulamak için ek işlemler yapılabilir
  }

  // Tema modunu ayarlama
  void setDarkMode(bool value) {
    isDarkMode.value = value;
    // Burada tema ayarlarını uygulamak için ek işlemler yapılabilir
  }
  @override
  Future<void> onReady() async {
    super.onReady();
    await onReadyGeneric(() async {
      await _getUser();
    });
  }

  Future<void> _getUser() async {
    user = sessionHandler.currentUser!;
  }

  void onTapRemoveAccount() {
    
  }
}
