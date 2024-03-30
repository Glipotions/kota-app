import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

/// A reusable widget for displaying cached images from network URLs.
///
/// Use this widget to efficiently load and cache images with optional error
/// and loading placeholders.
///
/// Example:
/// ```dart
/// GeneralCachedImage(
///   imageUrl: 'https://example.com/image.jpg',
///   fit: BoxFit.cover,
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
  /// - `errorWidget`: Widget to display when an error occurs
  /// during image loading.
  /// - `loadingWidget`: Widget to display while the image is being loaded.
  const GeneralCachedImage({
    super.key,
    this.imageUrl,
    this.fit,
    this.errorWidget,
    this.loadingWidget,
    this.externalImageWidget,
  });

  /// The URL of the image to be loaded.
  final String? imageUrl;

  /// How the image should be inscribed into the space.
  final BoxFit? fit;

  /// Widget to display when an error occurs during image loading.
  final Widget? errorWidget;

  /// Widget to display while the image is being loaded.
  final Widget? loadingWidget;

  /// Widget to display while the image is being loaded.
  final Widget Function(BuildContext, ImageProvider)? externalImageWidget;

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      imageUrl: imageUrl ?? '',
      errorWidget: (context, url, error) =>
          errorWidget ??
          const Icon(
            Icons.error_outline,
            color: Colors.red,
          ),
      fit: BoxFit.cover,
      placeholder: (context, url) =>
          loadingWidget ??
          const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
      placeholderFadeInDuration: const Duration(milliseconds: 500),
      filterQuality: FilterQuality.medium,
      imageBuilder: externalImageWidget ??
          (context, imageProvider) => Image(
                image: imageProvider,
                fit: fit ?? BoxFit.cover,
              ),
    );
  }
}

///
CachedNetworkImageProvider cachedImageProvider(String url) =>
    CachedNetworkImageProvider(url);
