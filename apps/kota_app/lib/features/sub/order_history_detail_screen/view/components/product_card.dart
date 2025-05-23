import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:kota_app/product/models/cart_product_model.dart';
import 'package:kota_app/product/utility/enums/module_padding_enums.dart';
import 'package:kota_app/product/utility/extentions/num_extension.dart';
import 'package:kota_app/product/widgets/card/bordered_image.dart';
import 'package:values/values.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({
    required this.item,
    required this.isCurrencyTL,
    this.onTapRemove,
    this.onTap,
    super.key,
  });

  final VoidCallback? onTap;
  final VoidCallback? onTapRemove;
  final CartProductModel item;
  final bool isCurrencyTL;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Container(
          margin: EdgeInsets.symmetric(
            horizontal: ModulePadding.s.value,
            vertical: ModulePadding.xxs.value,
          ),
          decoration: BoxDecoration(
            color: isDarkMode ? Colors.grey[850] : Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withAlpha(13), // withOpacity(0.05) yerine
                blurRadius: 10,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Product Image
              SizedBox(
                width: 80,
                height: 80,
                child: ClipRRect(
                  borderRadius: const BorderRadius.only(
                    topLeft: Radius.circular(12),
                    bottomLeft: Radius.circular(12),
                  ),
                  child: BorderedImage(
                    aspectRatio: 1,
                    imageUrl: item.pictureUrl ??
                        'https://kota-app.b-cdn.net/logo.jpg',
                    radius: const BorderRadius.only(
                      topLeft: Radius.circular(12),
                      bottomLeft: Radius.circular(12),
                    ),
                  ),
                ),
              ),
              // Product Details
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(ModulePadding.s.value),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Product Code
                      Text(
                        item.code,
                        style: context.labelMedium.copyWith(
                          color: Theme.of(context).primaryColor,
                          fontWeight: FontWeight.w500,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                      ),
                      const SizedBox(height: 4),
                      // Product Name
                      Text(
                        item.name ?? '',
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.titleSmall.copyWith(
                          color: isDarkMode ? Colors.white : Colors.black87,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      const SizedBox(height: 8),
                      // Price Information
                      Row(
                        children: [
                          // Quantity
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: ModulePadding.xs.value,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withAlpha(25), // withOpacity(0.1) yerine
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              '${item.quantity}x',
                              style: context.labelMedium.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          const SizedBox(width: 8),

                          // Kalan miktar (eğer varsa)
                          if (item.remainingQuantity != null)
                            Container(
                              padding: EdgeInsets.symmetric(
                                horizontal: ModulePadding.xs.value,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Theme.of(context)
                                    .colorScheme
                                    .secondary
                                    .withAlpha(50), // withOpacity(0.2) yerine
                                borderRadius: BorderRadius.circular(6),
                              ),
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Text(
                                    AppLocalization.getLabels(context).remainingQuantity,
                                    style: context.labelSmall.copyWith(
                                      color: Theme.of(context).colorScheme.secondary,
                                    ),
                                  ),
                                  const SizedBox(width: 4),
                                  Text(
                                    '${item.remainingQuantity}',
                                    style: context.labelMedium.copyWith(
                                      color: Theme.of(context).colorScheme.secondary,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ],
                              ),
                            ),

                          const Spacer(),

                          // Unit Price
                          Text(
                            isCurrencyTL
                                ? item.price.formatPrice()
                                : item.currencyUnitPrice!.formatPrice(),
                            style: context.bodyMedium.copyWith(
                              color: isDarkMode
                                  ? Colors.grey[300]
                                  : Colors.grey[600],
                            ),
                            maxLines: 1,
                            overflow: TextOverflow.ellipsis,
                          ),
                          const SizedBox(width: 8),

                          // Total Price
                          Text(
                            isCurrencyTL
                                ? (item.price * item.quantity).formatPrice()
                                : (item.currencyUnitPrice! * item.quantity)
                                    .formatPrice(),
                            style: context.titleSmall.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
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
