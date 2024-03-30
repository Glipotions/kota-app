import 'package:api/api.dart';
import 'package:bb_example_admin_panel/product/utility/enums/cache_enums.dart';
import 'package:common/common.dart';
import 'package:get/get.dart';

///Class that manages current session.
class SessionManager extends GetxController {
  final Rx<User> _currentUser = User().obs;
  final Rx<bool?> _loggedIn = Rx<bool?>(null);
  String? _token;

  ///Gets the current user value.
  User get currentUser => _currentUser.value;

  ///Sets the current user value.
  set currentUser(User value) => _currentUser
    ..firstRebuild = true
    ..value = value;

  ///Gets the current user token if it's saved.
  String? getUserToken() {
    return _token ??= LocaleManager.instance.getStringValue(
      key: CacheKey.token.name,
    );
  }

  ///Sets the current user token if it's saved.
  Future<void> setUserToken(String value) async {
    await LocaleManager.instance.setStringValue(
      key: CacheKey.token.name,
      value: value,
    );
    _token = value;
  }

  ///Gets the bool value that represnt if user logged in or not.
  bool isUserLogin() {
    if (_loggedIn.value == null) {
      final value =
          LocaleManager.instance.getBoolValue(key: CacheKey.loggedIn.name) ??
              false;
      _loggedIn.value = value;
    }
    return _loggedIn.value!;
  }

  ///Sets the bool value that represnt if user logged in or not.
  Future<void> setLoggedIn({required bool value}) async {
    await LocaleManager.instance.setBoolValue(
      key: CacheKey.loggedIn.name,
      value: value,
    );
    _loggedIn.value = value;
  }

  ///Logs out the current user.
  ///Sets logged in to false and removes the token from cache.
  Future<void> logOut() async {
    await Future.wait([
      LocaleManager.instance.removeAt(CacheKey.token.name),
      setLoggedIn(value: false),
    ]);
    currentUser = User();
  }

  ///Logs in the current user.
  ///Sets logged in to true and removes the token from cache.
  Future<void> logIn(LoginResponseModel res) async {
    currentUser = res.user!;
    await Future.wait([
      setLoggedIn(value: true),
      setUserToken(res.accessToken!),
    ]);
  }
}
