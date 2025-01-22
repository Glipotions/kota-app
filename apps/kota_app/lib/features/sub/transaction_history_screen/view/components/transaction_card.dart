part of '../transaction_history.dart';

class _TransactionCard extends StatelessWidget {
  const _TransactionCard({required this.item, required this.isCurrencyTL, this.onTap});

  final TransactionItem item;
  final bool isCurrencyTL;
  final VoidCallback? onTap;


  @override
  Widget build(BuildContext context) {
    final isDebit = item.borc != 0;
    final amount = isCurrencyTL
        ? isDebit
            ? item.borc ?? 0
            : item.alacak ?? 0
        : isDebit
            ? item.dovizBorc ?? 0
            : item.dovizAlacak ?? 0;
    final labels = AppLocalization.getLabels(context);

    return Hero(
      tag: 'transaction_${item.fisNo}',
      child: Card(
        elevation: 2,
        margin: EdgeInsets.zero,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: BorderSide(
            color: context.primary.withOpacity(0.1),
            width: 1,
          ),
        ),
        child: InkWell(
          borderRadius: BorderRadius.circular(12),
          onTap: onTap,
          child: Padding(
            padding: EdgeInsets.all(ModulePadding.m.value),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                Row(
                  children: [
                    // Transaction Icon
                    Container(
                      padding: EdgeInsets.all(ModulePadding.xs.value),
                      decoration: BoxDecoration(
                        color: isDebit
                            ? Colors.red.withOpacity(0.1)
                            : Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getTransactionIcon(item.fisTuru ?? ''),
                        color: isDebit ? Colors.red : Colors.green,
                        size: 24,
                      ),
                    ),
                    SizedBox(width: ModulePadding.s.value),

                    // Transaction Details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.fisTuru ?? '',
                            style: context.titleMedium.copyWith(
                              fontWeight: FontWeight.w600,
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

                    // Amount and Date
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

                // Balance Section
                if (item.bakiye != null) ...[
                  SizedBox(height: ModulePadding.s.value),
                  Divider(height: 1, color: context.primary.withOpacity(0.1)),
                  SizedBox(height: ModulePadding.s.value),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        labels.balance,
                        style: context.bodyMedium.copyWith(
                          color: context.secondary.withOpacity(0.7),
                        ),
                      ),
                      Text(
                        isCurrencyTL
                            ? item.bakiye!.formatPrice()
                            : item.dovizBakiye!.formatPrice(),
                        style: context.titleSmall.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }

  IconData _getTransactionIcon(String type) {
    switch (type.toLowerCase()) {
      case 'payment':
        return Icons.payment;
      case 'transfer':
        return Icons.swap_horiz;
      case 'withdrawal':
        return Icons.money_off;
      case 'deposit':
        return Icons.account_balance_wallet;
      default:
        return Icons.receipt_long;
    }
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
