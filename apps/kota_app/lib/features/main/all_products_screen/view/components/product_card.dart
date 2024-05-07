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
color: Colors.white,
        elevation: 2,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(8),
        ),
        child: Padding(
          padding: EdgeInsets.all(ModulePadding.xxs.value),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              AspectRatio(
                aspectRatio: 1, // Oranı artırdım (daha büyük resim)
                child: BorderedImage(
                  aspectRatio: 4,
                  imageUrl: item.pictureUrl != ''
                      ? item.pictureUrl!
                      : 'https://kota-app.b-cdn.net/logo.jpg',
                  radius: BorderRadius.vertical(
                      top: Radius.circular(8)), // Üst köşeleri yuvarlak
                ),
              ),
              SizedBox(height: ModulePadding.xs.value),
              Padding(
                padding:
                    EdgeInsets.symmetric(horizontal: ModulePadding.xxs.value),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      '${item.name ?? ''}',
                      style:
                          context.titleLarge.copyWith(color: context.secondary),
                      overflow: TextOverflow.ellipsis,
                      maxLines: 1,
                    ),
                    SizedBox(height: ModulePadding.xxs.value),

                    Text(
                      item.productName ?? '',
                      style: context.labelMedium
                          .copyWith(color: context.secondary),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    // Text(
                    //   item.price?.formatPrice() ?? '',
                    //   style:
                    //       context.titleMedium.copyWith(color: context.primary,),
                    // ),
                  ],
                ),
              ),
              SizedBox(height: ModulePadding.xs.value),
            ],
          ),
        ),
      ),
    );
  }
}
