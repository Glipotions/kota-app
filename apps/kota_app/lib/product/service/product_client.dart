import 'package:api/api.dart';
import 'package:common/common.dart';
import 'package:kota_app/product/service/module_header.dart';
import 'package:kota_app/product/utility/enums/cache_enums.dart';
import 'package:values/values.dart';

/// Client for handling module specific repositories
class ProductClient extends ModuleHeader {
  ProductClient._init();

  late DioClient _dioClient;

  bool _isInitialized = false;

  static final ProductClient _instance = ProductClient._init();

  /// Instance for [ProductClient]
  static ProductClient get instance {
    if (_instance._isInitialized) {
      _instance._refreshHeader();
    }
    return _instance;
  }

  /// This method needs to be called before using [ProductClient].
  /// Call to init.
  static Future<void> clientInit(EnvironmentConfigModel config) async {
    instance._dioClient = DioClient(
      baseUrl: config.apiBaseUrl,
      onUnauthorized: () {},
      headerParam: _instance.createHeader(),
    );
    _instance._isInitialized = true;
  }

  String? get _getUserToken =>
      LocaleManager.instance.getStringValue(key: CacheKey.token.name);

  void _refreshHeader() {
    _instance._dioClient.headerParam!.clear();
    _instance._dioClient.headerParam!
        .addAll(_instance.createHeader(token: _getUserToken));
  }

  /// Repository that contains Auth Related API calls
  AppService get appService =>
      AppService(dioClient: _dioClient);
}
