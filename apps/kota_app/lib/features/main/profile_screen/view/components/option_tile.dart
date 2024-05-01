part of '../profile.dart';

class _OptionTile extends StatelessWidget {
  const _OptionTile({required this.item});

  final OptionTileModel item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(ModulePadding.s.value),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  item.icon,
                  SizedBox(
                    width: ModulePadding.xs.value,
                  ),
                  Text(
                    item.title,
                    style: context.titleLarge,
                  ),
                ],
              ),
              SizedBox(
                height: ModulePadding.xs.value,
              ),
              Text(item.subTitle),
            ],
          ),
        ),
      ),
    );
  }
}

class OptionTileModel {

  OptionTileModel({
    required this.title,
    required this.subTitle,
    required this.icon,
    required this.onTap,
  });

  final String title;
  final String subTitle;
  final Widget icon;
  final VoidCallback onTap;
}
