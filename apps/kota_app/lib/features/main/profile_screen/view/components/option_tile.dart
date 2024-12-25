part of '../profile.dart';

class _OptionTile extends StatelessWidget {
  const _OptionTile({required this.item});

  final OptionTileModel item;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 2,
      shadowColor: Colors.black.withOpacity(0.1),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(16),
        side: BorderSide(
          color: context.primary.withOpacity(0.05),
          width: 1,
        ),
      ),
      child: InkWell(
        onTap: item.onTap,
        borderRadius: BorderRadius.circular(16),
        child: Padding(
          padding: EdgeInsets.all(ModulePadding.s.value),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: context.primary.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: item.icon,
                  ),
                  SizedBox(width: ModulePadding.xs.value),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.title,
                          style: context.titleMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        SizedBox(height: ModulePadding.xxxs.value),
                        Text(
                          item.subTitle,
                          style: context.bodyMedium.copyWith(
                            color: context.onSurface.withOpacity(0.7),
                          ),
                        ),
                      ],
                    ),
                  ),
                  Icon(
                    Icons.arrow_forward_ios,
                    size: 16,
                    color: context.onSurface.withOpacity(0.3),
                  ),
                ],
              ),
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
