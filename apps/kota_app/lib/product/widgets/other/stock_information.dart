import 'package:common/common.dart';
import 'package:flutter/material.dart';
import 'package:kota_app/product/utility/enums/module_padding_enums.dart';
import 'package:values/values.dart';

class StockInformationWidget extends StatelessWidget {
  const StockInformationWidget({
    required this.isInStock,
    super.key,
  });
  final bool isInStock;

  @override
  Widget build(BuildContext context) {
    final labels = AppLocalization.getLabels(context);
    final title = isInStock ? labels.inStock : labels.outOfStock;
    final color = isInStock ? context.tertiary : context.error;
    return Row(
      children: [
        CircleAvatar(
          radius: 6,
          backgroundColor: color,
        ),
        SizedBox(width: ModulePadding.xxxs.value),
        Text(
          title,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(color: color),
        ),
      ],
    );
  }
}
