import 'package:flutter/material.dart';
import 'package:kota_app/product/utility/enums/module_padding_enums.dart';
import 'package:values/values.dart';

class EmptyView extends StatelessWidget {
  const EmptyView({required this.message, super.key});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(
        horizontal: ModulePadding.xxs.value,
        vertical: ModulePadding.l.value,
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag,
              size: 128,
              color: context.primary.withOpacity(.5),
            ),
            SizedBox(
              height: ModulePadding.xxs.value,
            ),
            Text(
              message,
              style: context.titleMedium,
              textAlign: TextAlign.center,
            ),
            SizedBox(
              height: ModulePadding.l.value,
            ),
          ],
        ),
      ),
    );
  }
}
