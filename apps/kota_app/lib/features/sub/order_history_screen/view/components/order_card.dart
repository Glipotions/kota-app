part of '../order_history.dart';

class _OrderCard extends StatelessWidget {
  const _OrderCard({required this.item, required this.controller});

  final OrderItem item;
  final OrderHistoryController controller;

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    final labels = AppLocalization.getLabels(context);

    return Card(
      elevation: 2,
      margin: EdgeInsets.symmetric(
        horizontal: ModulePadding.s.value,
        vertical: ModulePadding.xs.value,
      ),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: () => controller.onTapOrderHistoryDetail(item.id!),
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: EdgeInsets.all(ModulePadding.m.value),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '${labels.orderNumber} #${item.kod ?? ''}',
                          style: context.titleMedium.copyWith(
                            fontWeight: FontWeight.bold,
                            color: isDarkMode ? Colors.white : Colors.black87,
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                        if (item.connectedBranchCurrentInfoName != null &&
                            item.connectedBranchCurrentInfoName!
                                .isNotEmpty) ...[
                          const SizedBox(height: 4),
                          Row(
                            children: [
                              Icon(
                                Icons.store_outlined,
                                size: 14,
                                color: isDarkMode
                                    ? Colors.grey[400]
                                    : Colors.grey[600],
                              ),
                              const SizedBox(width: 4),
                              Expanded(
                                child: Text(
                                  '${labels.subAccount}: ${item.connectedBranchCurrentInfoName}',
                                  style: context.bodySmall.copyWith(
                                    color: isDarkMode
                                        ? Colors.grey[400]
                                        : Colors.grey[600],
                                    fontWeight: FontWeight.w500,
                                  ),
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ],
                        const SizedBox(height: 4),
                        Text(
                          item.tarih?.displayToDateFormat() ?? '',
                          style: context.bodySmall.copyWith(
                            color: isDarkMode
                                ? Colors.grey[300]
                                : Colors.grey[600],
                          ),
                        ),
                        if (item.aciklama != null &&
                            item.aciklama!.isNotEmpty) ...[
                          const SizedBox(height: 8),
                          Container(
                            padding: EdgeInsets.all(ModulePadding.xs.value),
                            decoration: BoxDecoration(
                              color: isDarkMode
                                  ? Colors.grey[800]
                                  : Colors.grey[100],
                              borderRadius: BorderRadius.circular(8),
                              border: Border.all(
                                color: isDarkMode
                                    ? Colors.grey[700]!
                                    : Colors.grey[300]!,
                              ),
                            ),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Icon(
                                  Icons.notes_outlined,
                                  size: 16,
                                  color: isDarkMode
                                      ? Colors.grey[400]
                                      : Colors.grey[600],
                                ),
                                const SizedBox(width: 8),
                                Expanded(
                                  child: Text(
                                    item.aciklama!,
                                    style: context.bodySmall.copyWith(
                                      color: isDarkMode
                                          ? Colors.grey[300]
                                          : Colors.grey[700],
                                    ),
                                    maxLines: 2,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ],
                    ),
                  ),
                  PopupMenuButton<String>(
                    icon: Icon(
                      Icons.more_vert,
                      color: isDarkMode ? Colors.grey[300] : Colors.grey[700],
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    onSelected: (value) {
                      switch (value) {
                        case 'view':
                          controller.onTapOrderHistoryDetail(item.id!);
                        case 'edit':
                          controller.onTapEditOrder(item.id!);
                        case 'delete':
                          showDialog<bool>(
                            context: context,
                            barrierDismissible: false,
                            builder: (BuildContext context) => AlertDialog(
                              backgroundColor: Theme.of(context).cardColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(15),
                              ),
                              icon: Icon(
                                Icons.delete_outline,
                                color: Theme.of(context).colorScheme.error,
                                size: 32,
                              ),
                              title: Text(
                                labels.deleteOrder,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .titleLarge
                                      ?.color,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              content: Text(
                                labels.deleteOrderConfirmation,
                                style: TextStyle(
                                  color: Theme.of(context)
                                      .textTheme
                                      .bodyMedium
                                      ?.color,
                                ),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () =>
                                      Navigator.of(context).pop(false),
                                  child: Text(
                                    labels.cancel,
                                    style: TextStyle(
                                      color: Theme.of(context)
                                          .textTheme
                                          .bodyMedium
                                          ?.color,
                                    ),
                                  ),
                                ),
                                ElevatedButton(
                                  onPressed: () {
                                    Navigator.of(context).pop(true);
                                    controller
                                        .onTapDeleteOrderHistory(item.id!);
                                  },
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor:
                                        Theme.of(context).colorScheme.error,
                                    foregroundColor: Colors.white,
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                  ),
                                  child: Text(labels.delete),
                                ),
                              ],
                              actionsPadding: const EdgeInsets.all(16),
                            ),
                          );
                        case 'pdf':
                          controller.onTapOrderPdfCard(item.id!);
                      }
                    },
                    itemBuilder: (BuildContext context) {
                      return [
                        PopupMenuItem(
                          value: 'view',
                          child: Row(
                            children: [
                              const Icon(Icons.visibility_outlined, size: 20),
                              const SizedBox(width: 8),
                              Text(labels.details),
                            ],
                          ),
                        ),
                        if (item.canBeDeleted ?? false || kDebugMode)
                          PopupMenuItem(
                            value: 'edit',
                            child: Row(
                              children: [
                                const Icon(Icons.edit_outlined, size: 20),
                                const SizedBox(width: 8),
                                Text(labels.edit),
                              ],
                            ),
                          ),
                        if (item.canBeDeleted ?? false || kDebugMode)
                          PopupMenuItem(
                            value: 'delete',
                            child: Row(
                              children: [
                                const Icon(Icons.delete_outline, size: 20),
                                const SizedBox(width: 8),
                                Text(labels.delete),
                              ],
                            ),
                          ),
                        PopupMenuItem(
                          value: 'pdf',
                          child: Row(
                            children: [
                              const Icon(Icons.picture_as_pdf_outlined, size: 20),
                              const SizedBox(width: 8),
                              Text(labels.downloadPdf),
                            ],
                          ),
                        ),
                      ];
                    },
                  ),
                ],
              ),
              const SizedBox(height: 12),
              Divider(
                color: isDarkMode ? Colors.grey[800] : Colors.grey[200],
                height: 1,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: item.canBeDeleted!
                          ? Colors.amber.shade50
                          : !item.durum!
                              ? Colors.green.shade50
                              : Colors.blue.shade50,
                      borderRadius: BorderRadius.circular(20),
                      border: Border.all(
                        color: item.canBeDeleted!
                            ? Colors.amber.shade300
                            : !item.durum!
                                ? Colors.green.shade300
                                : Colors.blue.shade300,
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Icon(
                          item.canBeDeleted!
                              ? Icons.schedule
                              : !item.durum!
                                  ? Icons.check_circle
                                  : Icons.sync,
                          size: 16,
                          color: item.canBeDeleted!
                              ? Colors.amber.shade700
                              : !item.durum!
                                  ? Colors.green.shade700
                                  : Colors.blue.shade700,
                        ),
                        const SizedBox(width: 4),
                        Text(
                          item.canBeDeleted!
                              ? labels.waiting
                              : !item.durum!
                                  ? labels.completed
                                  : labels.preparing,
                          style: context.labelMedium.copyWith(
                            color: item.canBeDeleted!
                                ? Colors.amber.shade700
                                : !item.durum!
                                    ? Colors.green.shade700
                                    : Colors.blue.shade700,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Spacer(),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      Text(
                        labels.totalAmount,
                        style: context.labelSmall.copyWith(
                          color:
                              isDarkMode ? Colors.grey[300] : Colors.grey[600],
                        ),
                      ),
                      const SizedBox(height: 2),
                      Text(
                        (item.toplamTutar ?? 0).formatPrice(),
                        style: context.titleMedium.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).primaryColor,
                        ),
                      ),
                    ],
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
