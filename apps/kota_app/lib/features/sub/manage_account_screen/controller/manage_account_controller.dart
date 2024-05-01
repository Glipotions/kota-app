import 'package:api/api.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:kota_app/product/base/controller/base_controller.dart';
import 'package:kota_app/product/managers/session_handler.dart';

class ManageAccountController extends BaseControllerInterface {
  ManageAccountController();

  SessionHandler get sessionHandler => SessionHandler.instance;

  final Rx<User> _user =
      Rx(User());

  User get user => _user.value;
  set user(User value) => _user.value = value;

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
