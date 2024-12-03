part of '../cart.dart';

class _ProductCard extends StatelessWidget {
  const _ProductCard({required this.item, this.onTapRemove, this.onTap});
  final VoidCallback? onTap;
  final VoidCallback? onTapRemove;
  final CartProductModel item;

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
                      imageUrl: item.pictureUrl!,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Padding(
                  padding: EdgeInsets.all(ModulePadding.s.value),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Text(
                        item.name!,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: context.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                      Text(
                        item.code,
                        style: context.bodySmall?.copyWith(
                          color: Colors.grey,
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
                              color: Theme.of(context).primaryColor.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(ModuleRadius.s.value),
                            ),
                            child: Text(
                              '${item.quantity}x',
                              style: context.titleSmall?.copyWith(
                                color: Theme.of(context).primaryColor,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                          SizedBox(width: ModulePadding.xs.value),
                          Expanded(
                            child: Text(
                              item.price.formatPrice(),
                              style: context.titleSmall,
                            ),
                          ),
                          Text(
                            (item.price * item.quantity).formatPrice(),
                            style: context.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                              color: Theme.of(context).primaryColor,
                            ),
                          ),
                        ],
                      ),
                      SizedBox(height: ModulePadding.xs.value),
                      Align(
                        alignment: Alignment.centerRight,
                        child: TextButton.icon(
                          onPressed: onTapRemove,
                          icon: const Icon(Icons.delete_outline, size: 20),
                          label: const Text('Ürünü Kaldır'),
                          style: TextButton.styleFrom(
                            foregroundColor: Colors.red,
                            padding: EdgeInsets.symmetric(
                              horizontal: ModulePadding.xs.value,
                            ),
                          ),
                        ),
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
