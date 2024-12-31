import 'package:common/common.dart';
import 'package:kota_app/product/utility/enums/cache_enums.dart';

class RoleManager {
  RoleManager._init();
  static final RoleManager _instance = RoleManager._init();
  static RoleManager get instance => _instance;

  List<String> _userRoles = [];
  List<String> get userRoles => _userRoles;

  Future<void> setUserRoles(List<String> roles) async {
    _userRoles = roles;
    await LocaleManager.instance.setStringListValue(
      key: CacheKey.userRoles.name,
      value: roles,
    );
  }

  Future<void> loadUserRoles() async {
    final roles = LocaleManager.instance.getStringListValue(
      key: CacheKey.userRoles.name,
    );
    if (roles != null) {
      _userRoles = roles;
    }
  }

  void clearRoles() {
    _userRoles = [];
    LocaleManager.instance.removeAt(CacheKey.userRoles.name);
  }

  bool hasRole(String role) => _userRoles.contains(role);
  
  bool hasAnyRole(List<String> roles) => 
      roles.any((role) => _userRoles.contains(role));

  bool hasAllRoles(List<String> roles) => 
      roles.every((role) => _userRoles.contains(role));
}
