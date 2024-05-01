import 'package:bb_example_app/product/utility/enums/module_padding_enums.dart';
import 'package:flutter/material.dart';
import 'package:values/values.dart';

class StockInformationWidget extends StatelessWidget {
  const StockInformationWidget({
    required this.isInStock,
    super.key,
  });
  final bool isInStock;

  @override
  Widget build(BuildContext context) {
    final title = isInStock ? 'Stok Mevcut' : 'Stok Mevcut Değil';
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
