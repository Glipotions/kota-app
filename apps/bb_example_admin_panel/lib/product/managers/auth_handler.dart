import 'package:bb_example_admin_panel/product/utility/enums/cache_enums.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';

class AuthHandler extends ChangeNotifier {
  AuthHandler._init();

  static final AuthHandler _instance = AuthHandler._init();

  ///Returns instace for AuthHandler
  static AuthHandler get instance => _instance;

  UserAuthStatus _userAuthStatus = UserAuthStatus.notInitialized;
  UserAuthStatus get userAuthStatus => _userAuthStatus;
  set userAuthStatus(UserAuthStatus value) {
    _userAuthStatus = value;
    notifyListeners();
  }


  Future<void> initializeValue()async{
    final isUserLoggedIn =
        LocaleManager.instance.getBoolValue(key: CacheKey.loggedIn.name) ??
            false;
    if(isUserLoggedIn){
      userAuthStatus=UserAuthStatus.authorized;
    }else{
      userAuthStatus=UserAuthStatus.unAuthorized;
    }
  }
}

enum UserAuthStatus {
  notInitialized,
  unAuthorized,
  authorized,
}
