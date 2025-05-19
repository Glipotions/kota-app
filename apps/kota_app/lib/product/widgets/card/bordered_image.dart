import 'package:flutter/material.dart';
import 'package:kota_app/product/utility/enums/module_radius_enums.dart';
import 'package:widgets/widget.dart';

/// A widget that displays an image with a border radius and aspect ratio.
/// Uses the optimized image service for better performance.
class BorderedImage extends StatelessWidget {
  /// Creates a BorderedImage widget.
  ///
  /// Parameters:
  /// - `imageUrl`: The URL of the image to be loaded.
  /// - `aspectRatio`: The aspect ratio of the image container.
  /// - `radius`: The border radius of the image.
  /// - `fit`: How the image should be inscribed into the space.
  /// - `width`: The width of the image.
  /// - `height`: The height of the image.
  /// - `quality`: Image quality (1-100), defaults to 85.
  const BorderedImage({
    required this.imageUrl,
    super.key,
    this.aspectRatio,
    this.radius,
    this.fit,
    this.width,
    this.height,
    this.quality = 85,
  });

  /// The URL of the image to be loaded.
  final String imageUrl;

  /// The aspect ratio of the image container.
  final double? aspectRatio;

  /// The border radius of the image.
  final BorderRadius? radius;

  /// How the image should be inscribed into the space.
  final BoxFit? fit;

  /// The width of the image.
  final double? width;

  /// The height of the image.
  final double? height;

  /// Image quality (1-100), defaults to 85.
  final int quality;

  @override
  Widget build(BuildContext context) {
    // Calculate dimensions based on aspect ratio if needed
    double? calculatedWidth = width;
    double? calculatedHeight = height;

    if (aspectRatio != null) {
      if (width != null && height == null) {
        calculatedHeight = width! / aspectRatio!;
      } else if (height != null && width == null) {
        calculatedWidth = height! * aspectRatio!;
      }
    }

    return AspectRatio(
      aspectRatio: aspectRatio ?? 343 / 250,
      child: GeneralCachedImage(
        imageUrl: imageUrl,
        fit: fit ?? BoxFit.cover,
        width: calculatedWidth,
        height: calculatedHeight,
        borderRadius: radius ?? BorderRadius.circular(ModuleRadius.xl.value),
        quality: quality,
      ),
    );
  }
}
