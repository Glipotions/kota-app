import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:widgets/src/image/optimized_image_service.dart';

/// A reusable widget for displaying cached images from network URLs.
///
/// Use this widget to efficiently load and cache images with optional error
/// and loading placeholders. This widget uses the OptimizedImageService
/// to provide better image loading performance and caching.
///
/// Example:
/// ```dart
/// GeneralCachedImage(
///   imageUrl: 'https://example.com/image.jpg',
///   fit: BoxFit.cover,
///   width: 200,
///   height: 150,
///   errorWidget: Icon(Icons.error),
///   loadingWidget: Center(
///     child: CircularProgressIndicator.adaptive(),
///   ),
/// );
/// ```
class GeneralCachedImage extends StatelessWidget {
  /// Creates a GeneralCachedImage widget.
  ///
  /// Parameters:
  /// - `imageUrl`: The URL of the image to be loaded.
  /// - `fit`: How the image should be inscribed into the space.
  /// - `width`: The width to request for the image.
  /// - `height`: The height to request for the image.
  /// - `borderRadius`: Optional border radius for the image.
  /// - `quality`: Image quality (1-100), defaults to 85.
  /// - `errorWidget`: Widget to display when an error occurs during image loading.
  /// - `loadingWidget`: Widget to display while the image is being loaded.
  /// - `externalImageWidget`: Custom widget builder for the loaded image.
  const GeneralCachedImage({
    super.key,
    this.imageUrl,
    this.fit,
    this.width,
    this.height,
    this.borderRadius,
    this.quality = 85,
    this.errorWidget,
    this.loadingWidget,
    this.externalImageWidget,
  });

  /// The URL of the image to be loaded.
  final String? imageUrl;

  /// How the image should be inscribed into the space.
  final BoxFit? fit;

  /// The width to request for the image.
  final double? width;

  /// The height to request for the image.
  final double? height;

  /// Optional border radius for the image.
  final BorderRadius? borderRadius;

  /// Image quality (1-100), defaults to 85.
  final int quality;

  /// Widget to display when an error occurs during image loading.
  final Widget? errorWidget;

  /// Widget to display while the image is being loaded.
  final Widget? loadingWidget;

  /// Custom widget builder for the loaded image.
  final Widget Function(BuildContext, ImageProvider)? externalImageWidget;

  @override
  Widget build(BuildContext context) {
    return OptimizedImageService.loadImage(
      imageUrl: imageUrl ?? '',
      fit: fit ?? BoxFit.cover,
      width: width,
      height: height,
      borderRadius: borderRadius,
      quality: quality,
      errorWidget: errorWidget,
      loadingWidget: loadingWidget,
      imageBuilder: externalImageWidget,
    );
  }
}

/// Creates a cached network image provider with optimized settings
CachedNetworkImageProvider cachedImageProvider(String url, {int? width, int? height, int quality = 85}) {
  final optimizedUrl = OptimizedImageService.getOptimizedUrl(
    url,
    width: width,
    height: height,
    quality: quality,
  );

  return CachedNetworkImageProvider(
    optimizedUrl,
    cacheManager: OptimizedCacheManager.instance,
    maxWidth: width,
    maxHeight: height,
  );
}
