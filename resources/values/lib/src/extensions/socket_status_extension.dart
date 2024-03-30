import 'package:values/values.dart';

/// Flutter extension for the [SocketStatus] enum, providing convenient methods
/// to check the status of loading operations.
extension SocketStatusExtension on SocketStatus {
  /// Returns `true` if the loading status is [SocketStatus.loading].
  bool get isLoading => this == SocketStatus.loading;

  /// Returns `true` if the loading status is [SocketStatus.error].
  bool get isError => this == SocketStatus.error;

  /// Returns `true` if the loading status is [SocketStatus.connected].
  bool get isConnected => this == SocketStatus.connected;
}
