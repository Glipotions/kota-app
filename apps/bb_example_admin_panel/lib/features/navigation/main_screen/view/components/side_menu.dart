part of '../main_view.dart';

class _SideMenu extends StatelessWidget {
  const _SideMenu({
    required this.items,
  });

  final List<DrawerItem> items;

  @override
  Widget build(BuildContext context) {
    return Drawer(
      shape: const RoundedRectangleBorder(),
      child: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(ModulePadding.s.value),
            child: CirclularImage(
              assetImage: const ImageAssets().exampleImage,
            ),
          ),
          ...List.generate(
            items.length,
            (index) => Padding(
              padding: EdgeInsets.all(ModulePadding.s.value).copyWith(top: 0),
              child: _DrawerListTile(item: items[index]),
            ),
          ),
        ],
      ),
    );
  }
}

class _DrawerListTile extends StatelessWidget {
  const _DrawerListTile({
    required this.item,
  });

  final DrawerItem item;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: item.onTap,
      child: Row(
        children: [
          item.svg.svg(color: context.primary),
          SizedBox(
            width: ModulePadding.xxs.value,
          ),
          Expanded(
            child: Text(
              item.title,
              style: context.titleSmall,
              maxLines: 1,
              overflow: TextOverflow.ellipsis,
            ),
          ),
        ],
      ),
    );
  }
}
