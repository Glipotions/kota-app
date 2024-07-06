
import 'package:flutter/material.dart';
import 'package:kota_app/product/models/cart_product_model.dart';
import 'package:kota_app/product/utility/enums/module_padding_enums.dart';
import 'package:values/values.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({required this.item, this.onTapRemove, this.onTap});
  final VoidCallback? onTap;
  final VoidCallback? onTapRemove;
  final CartProductModel item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: IntrinsicHeight(
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // Expanded(
              //   flex: 2,
              //   child: BorderedImage(
              //     radius: BorderRadius.only(
              //       bottomLeft: Radius.circular(ModuleRadius.m.value),
              //       topLeft: Radius.circular(ModuleRadius.m.value),
              //     ),
              //     aspectRatio: 164 / 80,
              //     imageUrl: item.pictureUrl!,
              //   ),
              // ),
              // SizedBox(
              //   width: ModulePadding.xxs.value,
              // ),
              Expanded(
                flex: 3,
                child: Padding(
                  padding: EdgeInsets.all(ModulePadding.s.value)
                      .copyWith(left: ModulePadding.xs.value),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Column(
                        children: [
                          Text(
                            '${item.code} - ${item.name}',
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: context.bodySmall,
                          ),
                          
                        ],
                      ),
                      Row(
                        children: [
                          Text(
                            '${item.quantity}x',
                            style: context.titleSmall,
                          ),
                          Text(
                            item.price.formatPrice(),
                            style: context.titleSmall,
                            textAlign: TextAlign.end,
                          ),
                          const Spacer(),
                          Text(
                            '=',
                            style: context.titleSmall,
                            textAlign: TextAlign.start,
                          ),
                          Text(
                            (item.price * item.quantity).formatPrice(),
                            style: context.titleSmall,
                            textAlign: TextAlign.end,
                          ),
                        ],
                      ),
                      SizedBox(
                        height: ModulePadding.xxxs.value,
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
