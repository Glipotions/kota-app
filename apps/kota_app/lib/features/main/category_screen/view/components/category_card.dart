import 'package:api/api.dart';
import 'package:flutter/material.dart';
import 'package:kota_app/product/utility/enums/module_padding_enums.dart';
import 'package:kota_app/product/utility/enums/module_radius_enums.dart';

class CategoryCard extends StatelessWidget {
  const CategoryCard({required this.category, super.key});
  final ProductCategoryModel category;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ModulePadding.s.value,
        vertical: ModulePadding.xxs.value,
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(ModuleRadius.xl.value),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            // AspectRatio(
            //   aspectRatio: 343 / 250,
            //   child: GeneralCachedImage(
            //     imageUrl: category.pictureUrl,
            //     fit: BoxFit.cover,
            //   ),
            // ),
            Container(
              width: double.infinity,
              height: ModulePadding.xs.value,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                  colors: [
                    Colors.black.withOpacity(0.6),
                    Colors.transparent,
                  ],
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(ModulePadding.s.value),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    category.name!,
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: ModulePadding.m.value,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
