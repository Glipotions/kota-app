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
  final RxList<UserOperationClaimResponseModel> _userClaims = <UserOperationClaimResponseModel>[].obs;
  List<UserOperationClaimResponseModel> get userClaims => _userClaims;

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
    if (currentUser != null) {
      await getUserClaims(currentUser!.id!);
    }
  }

  Future<void> getUserClaims(int userId) async {
    try {
     await ProductClient.instance.appService
          .getUserOperationClaims(userId)
          .handleRequest(
            onSuccess: (res) {
              if (res != null) {
                _userClaims.value = res;
              }
            },
            ignoreException: true,
            defaultResponse: [],
          );
    } catch (e) {
      debugPrint('Error getting user claims: $e');
    }
  }

  bool hasAuthorize(String claim) {
    return _userClaims.any((x) =>
        x.operationClaimName == claim || x.operationClaimName == 'admin');
  }

  bool hasClaim(String claim) {
    return _userClaims.any((x) => x.operationClaimName == claim);
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

  Future<void> logOut() async {
    await Future.wait([
      LocaleManager.instance.removeAt(CacheKey.token.name),
      setLoggedIn(value: false),
    ]);
    _userClaims.clear();
    currentUser = null;
    userAuthStatus = UserAuthStatus.unAuthorized;
  }

  Future<void> logIn({LoginResponseModel? res}) async {
    if (res != null) {
      currentUser = res.user;
      await Future.wait([
        setLoggedIn(value: true),
        setUserToken(res.accessToken!),
      ]);
      userAuthStatus = UserAuthStatus.authorized;
      await getUserClaims(res.user!.id!);
    }
  }

  Future<void> setLoggedIn({required bool value}) async {
    await LocaleManager.instance.setBoolValue(
      key: CacheKey.loggedIn.name,
      value: value,
    );
  }

  String? getUserToken() => LocaleManager.instance.getStringValue(
        key: CacheKey.token.name,
      );

  Future<void> setUserToken(String value) async =>
      await LocaleManager.instance.setStringValue(
        key: CacheKey.token.name,
        value: value,
      );
}

enum UserAuthStatus {
  notInitialized,
  unAuthorized,
  authorized,
}
