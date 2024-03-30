import 'package:local_auth/local_auth.dart';

///Class that handles Local Auth
class LocalAuthManager {
  LocalAuthManager._init();

  late final LocalAuthentication _localAuth;
  late final List<BiometricType> _availableBiometrics;

  static final LocalAuthManager _instance = LocalAuthManager._init();

  ///Gets LocalAuthManager instance
  static LocalAuthManager get instance => _instance;

  ///This method initializes the Local Auth Manager.
  static Future<void> initLocalAuthManager() async {
    instance._localAuth = LocalAuthentication();
    instance._availableBiometrics =
        await instance._localAuth.getAvailableBiometrics();
  }

  ///Return if there is any available biometric on device
  bool get isAnyBiometricAvailable =>
      isFaceIdAvailable || isFingerPrintAvailable;

  ///Returns if face id available
  bool get isFaceIdAvailable =>
      _availableBiometrics.contains(BiometricType.face);

  ///Returns if finger print available
  bool get isFingerPrintAvailable =>
      _availableBiometrics.contains(BiometricType.fingerprint);

  ///Starts biometricAuthProcess and returns result as [bool]
  Future<bool> biometricAuth({required String authenticationReason}) async {
    try {
      if (isAnyBiometricAvailable) {
        return false;
      }
      return await instance._localAuth.authenticate(
        localizedReason: authenticationReason,
        options: const AuthenticationOptions(
          useErrorDialogs: false,
          biometricOnly: true,
        ),
      );
    } catch (_) {
      return false;
    }
  }
}
