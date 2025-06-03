import 'package:flutter/material.dart';
import 'package:common/common.dart';
import 'package:kota_app/product/models/cart_product_model.dart';
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
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Card(
          margin: const EdgeInsets.symmetric(horizontal: 2, vertical: 1),
          elevation: 1,
          child: ListTile(
            dense: true,
            contentPadding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
            leading: SizedBox(
              width: 40,
              height: 40,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(4),
                child: BorderedImage(
                  aspectRatio: 1,
                  imageUrl: item.pictureUrl ?? 'https://kota-app.b-cdn.net/logo.jpg',
                  radius: BorderRadius.circular(4),
                ),
              ),
            ),
            title: Text(
              '${item.code} - ${item.name ?? ''}',
              style: context.bodySmall.copyWith(
                fontWeight: FontWeight.w500,
              ),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            subtitle: Text(
              '${item.quantity}x'
              '${item.remainingQuantity != null ? ' (${item.remainingQuantity})' : ''}'
              '${item.discountRate > 0 ? ' ${item.discountRate.toStringAsFixed(0)}%' : ''}',
              style: context.labelSmall.copyWith(fontSize: 10),
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  isCurrencyTL
                      ? item.price.formatPrice()
                      : item.currencyUnitPrice!.formatPrice(),
                  style: context.bodySmall.copyWith(
                    color: Colors.grey[600],
                    fontSize: 9,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
                Text(
                  isCurrencyTL
                      ? (item.price * item.quantity * (1 - item.discountRate / 100)).formatPrice()
                      : (item.currencyUnitPrice! * item.quantity * (1 - item.discountRate / 100))
                          .formatPrice(),
                  style: context.bodyMedium.copyWith(
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).primaryColor,
                    fontSize: 11,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
