part of '../order_history.dart';

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.item, required this.controller});

  final OrderItem item;
  final OrderHistoryController controller;

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: EdgeInsets.all(ModulePadding.xxs.value),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  item.tarih?.displayToDateFormat() ?? '',
                ),
                PopupMenuButton<String>(
                  onSelected: (value) {
                    if (value == 'Gör') {
                      controller.onTapOrderHistoryDetail(item.id!);
                    } else if (value == 'Düzenle') {
                      // Düzenle seçeneği için işlemler
                    }
                  },
                  itemBuilder: (BuildContext context) {
                    return {'Gör', 'Düzenle'}.map((String choice) {
                      return PopupMenuItem<String>(
                        value: choice,
                        child: Text(choice),
                      );
                    }).toList();
                  },
                ),
              ],
            ),
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
                  ),
                ),
                SizedBox(
                  width: ModulePadding.xxs.value,
                ),
                const Text('Tutar:'),
                SizedBox(
                  width: ModulePadding.xxxs.value,
                ),
                Text(
                  (item.toplamTutar ?? 0).formatPrice(),
                  style: context.titleLarge,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
