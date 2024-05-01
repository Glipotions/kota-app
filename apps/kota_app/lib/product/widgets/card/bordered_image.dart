import 'package:flutter/material.dart';
import 'package:kota_app/product/utility/enums/module_radius_enums.dart';
import 'package:widgets/widget.dart';

class BorderedImage extends StatelessWidget {
  const BorderedImage({
    required this.imageUrl,
    super.key,
    this.aspectRatio,
    this.radius,
  });

  final String imageUrl;
  final double? aspectRatio;
  final BorderRadius? radius;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius:radius ?? BorderRadius.circular(ModuleRadius.xl.value),
      child: AspectRatio(
        aspectRatio: aspectRatio ?? 343 / 250,
        child: GeneralCachedImage(imageUrl: imageUrl,fit: BoxFit.cover,),
      ),
    );
  }
}
