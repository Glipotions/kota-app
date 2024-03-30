import 'package:flutter/material.dart';
import 'package:values/values.dart';
import 'package:widgets/widget.dart';

class CirclularImage extends StatelessWidget {
  const CirclularImage({
    super.key,
    this.radius,
    this.imageUrl,
    this.assetImage,
  });

  final double? radius;
  final String? imageUrl;
  final AssetGeneralImage? assetImage;

  @override
  Widget build(BuildContext context) {
    return CircleAvatar(
      backgroundImage: imageUrl != null
          ? cachedImageProvider(imageUrl!)
          : assetImage!
              .image(
                fit: BoxFit.cover,
              )
              .image,
      radius: radius ?? 100,
    );
  }
}
