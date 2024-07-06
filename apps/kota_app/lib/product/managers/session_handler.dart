import 'package:api/api.dart';
import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:kota_app/product/managers/cart_controller.dart';
import 'package:kota_app/product/service/product_client.dart';
import 'package:kota_app/product/utility/enums/cache_enums.dart';

class SessionHandler extends ChangeNotifier {
  SessionHandler._init();

  static final SessionHandler _instance = SessionHandler._init();

  User? currentUser;

  ///Returns instace for AuthHandler
  static SessionHandler get instance => _instance;

  UserAuthStatus _userAuthStatus = UserAuthStatus.notInitialized;
  UserAuthStatus get userAuthStatus => _userAuthStatus;
  bool isInitRoute = true;
  bool isInitRoute2 = true;

  set userAuthStatus(UserAuthStatus value) {
    _userAuthStatus = value;
    onAuthStatusChanged();
    notifyListeners();
  }

  Future<void> init() async {
    await _initializeAuthStatus();
  }

  Future<void> _initializeAuthStatus() async {
    final isUserLoggedIn =
        LocaleManager.instance.getBoolValue(key: CacheKey.loggedIn.name) ??
            false;
    if (isUserLoggedIn) {
      await getCurrentUser();
    } else {
      userAuthStatus = UserAuthStatus.unAuthorized;
    }
  }

  Future<void> getCurrentUser() async {
    await ProductClient.instance.appService.currentUser().handleRequest(
          onSuccess: (res) async {
            await logIn(res: res!);
          },
          onIgnoreException: (err) async {
            await logOut();
          },
          ignoreException: true,
          defaultResponse: LoginResponseModel(),
        );
  }

  void onAuthStatusChanged() {
    if (userAuthStatus == UserAuthStatus.authorized) {
      Get.put(CartController());
    } else if (userAuthStatus == UserAuthStatus.unAuthorized) {
      Get.delete<CartController>();
    }
  }

  ///Logs out the current user.
  ///Sets logged in to false and removes the token from cache.
  Future<void> logOut() async {
    await Future.wait([
      LocaleManager.instance.removeAt(CacheKey.token.name),
      setLoggedIn(value: false),
    ]);
    currentUser = null;
    userAuthStatus = UserAuthStatus.unAuthorized;
  }

  ///Logs in the current user.
  ///Sets logged in to true and removes the token from cache.
  Future<void> logIn({required LoginResponseModel res}) async {
    currentUser = res.user;
    await Future.wait([
      setLoggedIn(value: true),
      setUserToken(res.accessToken!),
    ]);
    userAuthStatus = UserAuthStatus.authorized;
  }

  Future<void> setLoggedIn({required bool value}) async {
    await LocaleManager.instance.setBoolValue(
      key: CacheKey.loggedIn.name,
      value: value,
    );
  }

  ///Gets the current user token if it's saved.
  String? getUserToken() => LocaleManager.instance.getStringValue(
        key: CacheKey.token.name,
      );

  ///Sets the current user token if it's saved.
  Future<void> setUserToken(String value) async =>
      LocaleManager.instance.setStringValue(
        key: CacheKey.token.name,
        value: value,
      );
}

enum UserAuthStatus {
  notInitialized,
  unAuthorized,
  authorized,
}
