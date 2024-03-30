///Handles headers of this module for requests.
class ModuleHeader {
  ///Returns header to use in requests of this module.
  Map<String, String> createHeader({
    String? token,
    String lang = 'tr',
    Map<String, String> addMap = const {},
  }) {
    final map = <String, String>{
      'content-type': 'application/json',
      'authorization': 'Bearer ${token ?? ''}',
      'lang': lang,
    }..addAll(addMap);
    return map;
  }
}
