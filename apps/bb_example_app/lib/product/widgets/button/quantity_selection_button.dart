import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:values/values.dart';
import 'package:widgets/widget.dart';

class QuantitySelectionButton extends StatefulWidget {
  const QuantitySelectionButton({
    required this.cController, super.key,
  });

  final TextEditingController cController;

  @override
  State<QuantitySelectionButton> createState() =>
      _QuantitySelectionButtonState();
}

class _QuantitySelectionButtonState extends State<QuantitySelectionButton> {
  @override
  void initState() {
    super.initState();
    widget.cController.addListener(() {});
  }

  @override
  void dispose() {
    super.dispose();
    widget.cController.dispose();
  }

  void onTapIncrease() {
    var currentQty = int.tryParse(widget.cController.text);
    if (currentQty != null) {
      currentQty = currentQty + 1;
      widget.cController.text = currentQty.toString();
    } else {
      ToastMessage.showToastMessage(
        message: 'Lütfen geçerli bir adet giriniz.',
        type: ToastMessageType.error,
      );
    }
  }

  void onTapDecrease() {
    var currentQty = int.tryParse(widget.cController.text);
    if (currentQty != null) {
      currentQty = currentQty - 1;
      if (currentQty >= 0) {
        widget.cController.text = currentQty.toString();
      } else {
        ToastMessage.showToastMessage(
          message: "Ürün adeti 0'dan düşük olamaz.",
          type: ToastMessageType.error,
        );
      }
    } else {
      ToastMessage.showToastMessage(
        message: 'Lütfen geçerli bir adet giriniz.',
        type: ToastMessageType.error,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(onPressed: onTapDecrease, icon: const Icon(Icons.remove)),
        Expanded(
          child: TextFormField(
            onTapOutside: (_) => FocusScope.of(context).unfocus(),
            controller: widget.cController,
            textAlign: TextAlign.center,
            style: context.titleSmall.copyWith(color: context.primary),
            keyboardType: TextInputType.number,
            inputFormatters: <TextInputFormatter>[
              FilteringTextInputFormatter.digitsOnly,
            ],
          ),
        ),
        IconButton(onPressed: onTapIncrease, icon: const Icon(Icons.add)),
      ],
    );
  }
}
