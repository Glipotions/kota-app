

import 'package:device_info_plus/device_info_plus.dart';
import 'package:package_info_plus/package_info_plus.dart' as package;
import 'package:universal_io/io.dart';

///This class returns app informations.
///appName, packageName, version, buildNumber, buildSignature,deviceId
class AppInfo {
  AppInfo._init();

  static final AppInfo _instance = AppInfo._init();

  /// Returns instance for [AppInfo]
  static AppInfo get instance => _instance;

  /// The app name. `CFBundleDisplayName` on iOS, `application/label` on Android.
  late final String appName;

  /// The package name. `bundleIdentifier` on iOS, `getPackageName` on Android.
  late final String packageName;

  /// The package version. `CFBundleShortVersionString` on iOS,
  /// `versionName` on Android.
  late final String version;

  /// The build number. `CFBundleVersion` on iOS, `versionCode` on Android.
  late final String buildNumber;

  /// The build signature. Empty string on iOS, signing key signature (hex)
  /// on Android.
  late final String buildSignature;

  /// Unique UUID value identifying the current device.
  late final String deviceId;

  /// Unique value that represents deviceSerial
  // late final String deviceSerial;
  final String deviceSerial = 'PB8221C948991';

  /// String that represents device brand and Model
  late final String deviceBrandAndModel;

  /// Sets the current app info values. You have to call this once function
  /// before using any of its variable. It throws error if you call twice.
  static Future<void> init() async {
    final info = await package.PackageInfo.fromPlatform();
    instance._setPackageInfo(info);
    await instance._setDeviceId();
  }

  /// Sets the app info values based on given Mock values.
  /// This method written for testing.
  static void mockInit({
    String appName = '',
    String packageName = '',
    String version = '',
    String buildNumber = '',
    String buildSignature = '',
  }) {
    final info = package.PackageInfo(
      appName: appName,
      packageName: packageName,
      version: version,
      buildNumber: buildNumber,
      buildSignature: buildSignature,
    );
    instance._setPackageInfo(info);
  }

  void _setPackageInfo(package.PackageInfo info) {
    version = info.version;
    buildNumber = info.buildNumber;
    appName = info.appName;
    packageName = info.packageName;
    buildSignature = info.buildSignature;
  }

  Future<void> _setDeviceId() async {
    try {
      final deviceInfo = DeviceInfoPlugin();
      if (Platform.isIOS) {
        final iosDeviceInfo = await deviceInfo.iosInfo;
        deviceId = iosDeviceInfo.identifierForVendor!;
        deviceBrandAndModel = '${iosDeviceInfo.name} ${iosDeviceInfo.model}';
      } else if(Platform.isAndroid) {
        final androidDeviceInfo = await deviceInfo.androidInfo;
        deviceId = androidDeviceInfo.id;
        deviceBrandAndModel =
            ' ${androidDeviceInfo.manufacturer} ${androidDeviceInfo.model}';
      }  else if(Platform.isWindows){
          final windowsDeviceInfo = await deviceInfo.windowsInfo;
          deviceId = windowsDeviceInfo.deviceId;
          deviceBrandAndModel =
            '${windowsDeviceInfo.productName} ${windowsDeviceInfo.productType}';
      }else{
          final macosDeviceInfo = await deviceInfo.macOsInfo;
          deviceId = '';
          deviceBrandAndModel =
            '${macosDeviceInfo.computerName} ${macosDeviceInfo.model}';
      }
      
    } catch (e) {
      deviceId = '';
    }
  }
}
