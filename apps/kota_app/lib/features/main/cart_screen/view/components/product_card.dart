part of '../cart.dart';

class _ProductCard extends StatelessWidget {
  const _ProductCard(
      {required this.item, this.onTapRemove, this.onTap, this.currencyType});
  final VoidCallback? onTap;
  final VoidCallback? onTapRemove;
  final CartProductModel item;
  final int? currencyType;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(ModuleRadius.m.value),
        child: Card(
          elevation: 2,
          margin: EdgeInsets.zero,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(ModuleRadius.m.value),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 100,
                height: 100,
                child: Hero(
                  tag: 'product_${item.id}',
                  child: ClipRRect(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(ModuleRadius.m.value),
                      bottomLeft: Radius.circular(ModuleRadius.m.value),
                    ),
                    child: BorderedImage(
                      radius: BorderRadius.only(
                        bottomLeft: Radius.circular(ModuleRadius.m.value),
                        topLeft: Radius.circular(ModuleRadius.m.value),
                      ),
                      aspectRatio: 1,
                      imageUrl: item.pictureUrl ??
                          'https://kota-app.b-cdn.net/logo.jpg',
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(ModulePadding.xs.value),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Text(
                      //   item.code,
                      //   style: context.bodySmall?.copyWith(
                      //     color: Colors.grey,
                      //   ),
                      // ),
                      Text(
                        item.name!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.labelMedium.copyWith(
                          fontWeight: FontWeight.w500,
                          color: Theme.of(context).hintColor,
                        ),
                      ),
                      if (item.sizeName != null || item.colorName != null)
                        Padding(
                          padding:
                              EdgeInsets.only(top: ModulePadding.xxs.value),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                child: Row(
                                  children: [
                                    _buildChip(
                                      context,
                                      Icons.local_offer,
                                      item.code,
                                      Colors.grey.shade100,
                                    ),
                                    SizedBox(width: ModulePadding.xxs.value),
                                    if (item.sizeName != null)
                                      _buildChip(
                                        context,
                                        Icons.straighten,
                                        item.sizeName!,
                                        Colors.blue.shade50,
                                      ),
                                  ],
                                ),
                              ),
                              if (item.colorName != null)
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: ModulePadding.xxs.value),
                                    child: _buildChip(
                                      context,
                                      Icons.palette_outlined,
                                      item.colorName!,
                                      Colors.orange.shade50,
                                    ),
                                  ),
                                ),
                            ],
                          ),
                        ),

                      SizedBox(height: ModulePadding.xs.value),
                      Row(
                        children: [
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: ModulePadding.xs.value,
                              vertical: ModulePadding.xxxs.value,
                            ),
                            decoration: BoxDecoration(
                              color: Theme.of(context)
                                  .primaryColor
                                  .withOpacity(0.1),
                              borderRadius:
                                  BorderRadius.circular(ModuleRadius.s.value),
                            ),
                            child: Text(
                              '${item.quantity}x',
                              style: context.titleSmall.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: ModulePadding.xs.value),
                          Expanded(
                            child: Text(
                              CurrencyType.tl ==
                                      CurrencyType.fromValue(
                                        currencyType ?? 1,
                                      )
                                  ? item.price.formatPrice()
                                  : item.currencyUnitPrice!.formatPrice(),
                              style: context.titleSmall,
                              overflow: TextOverflow.ellipsis,
                            ),
                          ),
                          Text(
                            (CurrencyType.tl ==
                                        CurrencyType.fromValue(
                                          currencyType ?? 1,
                                        )
                                    ? (item.price * item.quantity)
                                    : (item.currencyUnitPrice! * item.quantity))
                                .formatPrice(),
                            style: context.titleMedium.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                            overflow: TextOverflow.ellipsis,
                          ),
                        ],
                      ),
                      // SizedBox(height: ModulePadding.xs.value),
                      // Align(
                      //   alignment: Alignment.centerRight,
                      //   child: TextButton.icon(
                      //     onPressed: onTapRemove,
                      //     icon: const Icon(Icons.delete_outline, size: 20),
                      //     label: const Text('Ürünü Kaldır'),
                      //     style: TextButton.styleFrom(
                      //       foregroundColor: Colors.red,
                      //       padding: EdgeInsets.symmetric(
                      //         horizontal: ModulePadding.xs.value,
                      //       ),
                      //     ),
                      //   ),
                      // ),
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

  Widget _buildChip(
    BuildContext context,
    IconData icon,
    String text,
    Color bgColor,
  ) {
    return Container(
      padding: EdgeInsets.symmetric(
        horizontal: ModulePadding.xxxs.value,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: bgColor,
        border: Border.all(
          color: Theme.of(context).dividerColor,
        ),
        borderRadius: BorderRadius.circular(ModuleRadius.xs.value),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 0,
            blurRadius: 1,
            offset: const Offset(0, 1),
          ),
        ],
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(
            icon,
            size: 14,
            color: Colors.black87,
          ),
          const SizedBox(width: 4),
          Text(
            text,
            style: context.labelSmall.copyWith(
              color: Colors.black87,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}
