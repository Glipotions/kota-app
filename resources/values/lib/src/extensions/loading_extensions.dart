

import 'package:values/values.dart';

/// Flutter extension for the [LoadingStatus] enum, providing convenient methods
/// to check the status of loading operations.
extension LoadingStatusExtension on LoadingStatus {
  /// Returns `true` if the loading status is [LoadingStatus.loading].
  bool get isLoading => this == LoadingStatus.loading;

  /// Returns `true` if the loading status is [LoadingStatus.init].
  bool get isInit => this == LoadingStatus.init;

  /// Returns `true` if the loading status is [LoadingStatus.error].
  bool get isError => this == LoadingStatus.error;

  /// Returns `true` if the loading status is [LoadingStatus.loaded].
  bool get isLoaded => this == LoadingStatus.loaded;

  /// Returns `true` if the loading status is [LoadingStatus.processing].
  bool get isProcessing => this == LoadingStatus.processing;
}
