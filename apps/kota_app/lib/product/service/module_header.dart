import 'package:kota_app/product/managers/session_handler.dart';

///Handles headers of this module for requests.
class ModuleHeader {
  ///Returns header to use in requests of this module.
  Map<String, String> createHeader({
    String? token,
    String lang = 'tr',
    Map<String, String> addMap = const {},
  }) {
    String? periodId;
    final sessionHandler = SessionHandler.instance;
    if (sessionHandler.userAuthStatus == UserAuthStatus.authorized) {
      periodId = sessionHandler.currentUser?.periodId.toString() ?? '';
    }
    final map = <String, String>{
      'content-type': 'application/json',
      'authorization': 'Bearer ${token ?? ''}',
      // 'donemId':,
      'lang': lang,
      'donemId': periodId ?? '',
    }..addAll(addMap);
    return map;
  }
}
