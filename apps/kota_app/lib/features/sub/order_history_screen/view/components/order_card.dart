part of '../order_history.dart';

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.item});

  final OrderItem item;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(ModulePadding.s.value),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            CustomChoiceChip(
              title: !item.durum! ? 'Tamamlandı' : 'Hazırlanıyor',
              isSelected: true,
            ),
            SizedBox(
              height: ModulePadding.m.value,
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                    child: Text(
                  item.kod ?? '',
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),),
                SizedBox(
                  width: ModulePadding.xxs.value,
                ),
                Text(
                  item.tarih?.displayToDateFormat() ?? '',
                ),
              ],
            ),
            SizedBox(
              height: ModulePadding.m.value,
            ),
            _AmountTile(
              title: 'Sipariş Tutarı',
              amount: item.toplamTutar ?? 0,
            ),
            // SizedBox(
            //   height: ModulePadding.m.value,
            // ),
            //  _AmountTile(
            //   title: 'Sipariş Sonrası Bakiye',
            //   amount: item.toplamTutar ?? 0,
            // ),
          ],
        ),
      ),
    );
  }
}

class _AmountTile extends StatelessWidget {
  const _AmountTile({
    required this.title, required this.amount,
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
