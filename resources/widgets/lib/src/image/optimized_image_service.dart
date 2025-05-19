import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_cache_manager/flutter_cache_manager.dart';

/// A custom cache manager for optimized image caching
class OptimizedCacheManager {
  static const key = 'optimizedCacheKey';
  static CacheManager instance = CacheManager(
    Config(
      key,
      stalePeriod: const Duration(days: 7), // Cache images for 7 days
      maxNrOfCacheObjects: 200, // Limit cache size
      repo: JsonCacheInfoRepository(databaseName: key),
      fileService: HttpFileService(),
    ),
  );
}

/// A service for loading and optimizing images
class OptimizedImageService {
  /// Constructs a URL with resizing parameters for CDN-based images
  static String getOptimizedUrl(String url, {int? width, int? height, int quality = 85}) {
    // Check if the URL is from a known CDN that supports image resizing
    if (url.contains('b-cdn.net')) {
      // BunnyCDN supports image resizing with query parameters
      final Uri uri = Uri.parse(url);
      final queryParams = <String, String>{
        ...uri.queryParameters,
      };
      
      // Add width parameter if provided
      if (width != null) {
        queryParams['width'] = width.toString();
      }
      
      // Add height parameter if provided
      if (height != null) {
        queryParams['height'] = height.toString();
      }
      
      // Add quality parameter
      queryParams['quality'] = quality.toString();
      
      // Build the new URL with query parameters
      return uri.replace(queryParameters: queryParams).toString();
    }
    
    // Return the original URL if it's not from a supported CDN
    return url;
  }
  
  /// Loads an image with optimized settings
  static Widget loadImage({
    required String imageUrl,
    BoxFit fit = BoxFit.cover,
    Widget? errorWidget,
    Widget? loadingWidget,
    double? width,
    double? height,
    int quality = 85,
    BorderRadius? borderRadius,
    Widget Function(BuildContext, ImageProvider)? imageBuilder,
  }) {
    // Handle empty or null URLs
    if (imageUrl.isEmpty) {
      return errorWidget ?? 
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: borderRadius,
          ),
          child: const Center(
            child: Icon(
              Icons.image_not_supported_outlined,
              color: Colors.grey,
            ),
          ),
        );
    }
    
    // Optimize the URL if possible
    final optimizedUrl = getOptimizedUrl(
      imageUrl,
      width: width?.toInt(),
      height: height?.toInt(),
      quality: quality,
    );
    
    // Create the widget
    Widget imageWidget = CachedNetworkImage(
      imageUrl: optimizedUrl,
      fit: fit,
      width: width,
      height: height,
      cacheManager: OptimizedCacheManager.instance,
      fadeInDuration: const Duration(milliseconds: 300),
      fadeOutDuration: const Duration(milliseconds: 300),
      placeholderFadeInDuration: const Duration(milliseconds: 300),
      errorWidget: (context, url, error) => 
        errorWidget ?? 
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: borderRadius,
          ),
          child: const Center(
            child: Icon(
              Icons.error_outline,
              color: Colors.red,
            ),
          ),
        ),
      placeholder: (context, url) => 
        loadingWidget ?? 
        Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            color: Colors.grey[200],
            borderRadius: borderRadius,
          ),
          child: const Center(
            child: CircularProgressIndicator.adaptive(),
          ),
        ),
      imageBuilder: imageBuilder ??
        (context, imageProvider) => Container(
          width: width,
          height: height,
          decoration: BoxDecoration(
            borderRadius: borderRadius,
            image: DecorationImage(
              image: imageProvider,
              fit: fit,
            ),
          ),
        ),
      memCacheWidth: width?.toInt(),
      memCacheHeight: height?.toInt(),
      maxWidthDiskCache: (width != null) ? (width * 2).toInt() : null, // For high-DPI screens
      maxHeightDiskCache: (height != null) ? (height * 2).toInt() : null, // For high-DPI screens
    );
    
    // Apply border radius if provided
    if (borderRadius != null && imageBuilder == null) {
      imageWidget = ClipRRect(
        borderRadius: borderRadius,
        child: imageWidget,
      );
    }
    
    return imageWidget;
  }
}
