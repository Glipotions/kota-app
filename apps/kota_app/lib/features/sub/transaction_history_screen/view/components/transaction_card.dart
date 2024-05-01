part of '../transaction_history.dart';

class _TransactionCard extends StatelessWidget {
  const _TransactionCard({required this.item});

  final TransactionItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(ModulePadding.s.value),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Text(
              item.fisTuru ?? '',
              style: context.titleLarge,
            ),
            SizedBox(
              height: ModulePadding.xxxs.value,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    item.fisNo ?? '',
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SizedBox(
                  width: ModulePadding.xxs.value,
                ),
                Text(
                  item.tarih!.displayToDateFormat(),
                ),
              ],
            ),
            SizedBox(
              height: ModulePadding.m.value,
            ),
            _AmountTile(
              title: 'İşlem Tutarı',
              amount: item.borc != 0
                  ? item.borc ?? 0
                  : item.alacak != 0
                      ? item.alacak ?? 0
                      : 0,
            ),
            SizedBox(
              height: ModulePadding.m.value,
            ),
            _AmountTile(
              title: 'Sipariş Sonrası Bakiye',
              amount: item.bakiye ?? 0,
            ),
          ],
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
      children: [
        Expanded(child: Text(title)),
        Text(
          amount.formatPrice(),
          style: context.titleLarge,
        ),
      ],
    );
  }
}
