part of '../all_products.dart';

class ProductCard extends StatelessWidget {
  const ProductCard({required this.item, super.key, this.onTap});

  final VoidCallback? onTap;
  final ProductGroupItem item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(ModulePadding.xxs.value),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const AspectRatio(
                aspectRatio: 311 / 140,
                child: BorderedImage(
                  imageUrl: 'https://kota-app.b-cdn.net/1000-1.jpg',
                ),
                // imageUrl: 'https://thispersondoesnotexist.com/'),
              ),
              SizedBox(height: ModulePadding.xxs.value),
              Row(
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.name ?? '',
                          style: context.titleLarge
                              .copyWith(color: context.primary),
                        ),
                        SizedBox(height: ModulePadding.xxs.value),
                        Text(
                          'Kod: ${item.code ?? ''}',
                          style: context.titleMedium
                              .copyWith(color: context.primary),
                          overflow: TextOverflow.ellipsis,
                          maxLines: 2,
                        ),
                      ],
                    ),
                  ),
                  Text(
                    item.price?.formatPrice() ?? '',
                    style: context.titleLarge.copyWith(color: context.primary),
                  ),
                ],
              ),
              SizedBox(height: ModulePadding.l.value),
            ],
          ),
        ),
      ),
    );
  }
}
