part of '../transaction_history.dart';

class _TransactionCard extends StatelessWidget {
  const _TransactionCard({required this.item});

  final TransactionItem item;

  @override
  Widget build(BuildContext context) {
    final bool isDebit = item.borc != 0;
    final double amount = isDebit ? item.borc ?? 0 : item.alacak ?? 0;

    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(
        horizontal: ModulePadding.s.value,
        vertical: ModulePadding.xxs.value,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
        side: BorderSide(
          color: context.primary.withOpacity(0.1),
          width: 1,
        ),
      ),
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: () {
          // TODO: Implement transaction detail view
        },
        child: Padding(
          padding: EdgeInsets.all(ModulePadding.m.value),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    padding: EdgeInsets.all(ModulePadding.xs.value),
                    decoration: BoxDecoration(
                      color: isDebit 
                          ? Colors.red.withOpacity(0.1)
                          : Colors.green.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Icon(
                      isDebit ? Icons.remove_circle : Icons.add_circle,
                      color: isDebit ? Colors.red : Colors.green,
                      size: 24,
                    ),
                  ),
                  SizedBox(width: ModulePadding.s.value),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          item.fisTuru ?? '',
                          style: context.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        SizedBox(height: ModulePadding.xxs.value),
                        Text(
                          item.fisNo ?? '',
                          style: context.bodyMedium.copyWith(
                            color: context.secondary.withOpacity(0.7),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ],
                    ),
                  ),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        amount.formatPrice(),
                        style: context.titleMedium.copyWith(
                          color: isDebit ? Colors.red : Colors.green,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: ModulePadding.xxs.value),
                      Text(
                        item.tarih!.displayToDateFormat(),
                        style: context.bodySmall.copyWith(
                          color: context.secondary.withOpacity(0.5),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              if (item.bakiye != null) ...[
                SizedBox(height: ModulePadding.s.value),
                Divider(height: 1, color: context.primary.withOpacity(0.1)),
                SizedBox(height: ModulePadding.s.value),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Bakiye',
                      style: context.bodyMedium.copyWith(
                        color: context.secondary.withOpacity(0.7),
                      ),
                    ),
                    Text(
                      item.bakiye!.formatPrice(),
                      style: context.titleMedium.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                  ],
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

class _AmountTile extends StatelessWidget {
  const _AmountTile({
    required this.title,
    required this.amount,
  });

  final String title;
  final double amount;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          title,
          style: context.bodyMedium.copyWith(
            color: context.secondary.withOpacity(0.7),
          ),
        ),
        Text(
          amount.formatPrice(),
          style: context.titleMedium.copyWith(
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
