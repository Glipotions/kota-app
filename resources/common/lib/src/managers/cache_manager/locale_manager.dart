import 'package:shared_preferences/shared_preferences.dart';


///You can manage everything related to caching using this class.
class LocaleManager {

    LocaleManager._init();
    late final SharedPreferences _preferences;

    static final LocaleManager _instance = LocaleManager._init();

    ///Returns instace for LocaleManager
    static LocaleManager get instance => _instance;

    ///Initialize the Shared Preferances. To use it in testing you can use
    ///initValue parameter within this method.
    static Future<void> cacheInit([SharedPreferences? initValue]) async {
      instance._preferences = 
      initValue ?? await SharedPreferences.getInstance();
    }

  ///This method is written for setting mock values while testing.
  Future<SharedPreferences> setMockValues(Map<String,Object> mockValues)async{
    // ignore: invalid_use_of_visible_for_testing_member
    SharedPreferences.setMockInitialValues(mockValues);
    return SharedPreferences.getInstance();
  }

  ///This method clears all cache.
  Future<void> clearAll() async {
    await _preferences.clear();
  }

  ///This method clears value at given key.
  Future<void> removeAt(String key) async {
    await _preferences.remove(key);
  }

  ///This method sets String value for given key.
  Future<void> setStringValue({
    required String key,
    required String value,
  }) async {
    await _preferences.setString(key, value);
  }

  ///This method sets List<String> value for given key.
  Future<void> setStringListValue({
    required String key,
    required List<String> value,
  }) async {
    await _preferences.setStringList(key, value);
  }

  ///This method sets bool value for given key.
  Future<void> setBoolValue({required String key,required  bool value}) async {
    await _preferences.setBool(key, value);
  }

  ///This method sets int value for given key.
  Future<void> setIntValue({required String key,required  int value}) async {
    await _preferences.setInt(key, value);
  }

  ///This method get String value at given key.
  String? getStringValue({required String key}) => _preferences.getString(key);

  ///This method get bool value at given key.
  bool? getBoolValue({required String key}) => _preferences.getBool(key);

  ///This method get int value at given key.
  int? getIntValue({required String key}) => _preferences.getInt(key);
}
