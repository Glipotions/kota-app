import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuantitySelectionButton extends StatefulWidget {
  const QuantitySelectionButton({
    required this.cController,
    this.productCountInPackage = 2,
    super.key,
  });

  final TextEditingController cController;
  final int? productCountInPackage;

  @override
  State<QuantitySelectionButton> createState() =>
      _QuantitySelectionButtonState();
}

class _QuantitySelectionButtonState extends State<QuantitySelectionButton> {
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    widget.cController.addListener(_handleInputAdjustment);
  }

  @override
  void dispose() {
    _debounce?.cancel();
    widget.cController.removeListener(_handleInputAdjustment);
    super.dispose();
  }

  void _handleInputAdjustment() {
    if (_debounce?.isActive ?? false) _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 500), () {
      final text = widget.cController.text;
      int? currentQty = int.tryParse(text);
      if (currentQty != null) {
        int roundedQty = (currentQty ~/ widget.productCountInPackage!) *
            widget.productCountInPackage!;
        if (roundedQty != currentQty) {
          widget.cController.value = TextEditingValue(
            text: roundedQty.toString(),
            selection:
                TextSelection.collapsed(offset: roundedQty.toString().length),
          );
        }
      }
    });
  }

  void onTapIncrease() {
    var currentQty = int.tryParse(widget.cController.text);
    if (currentQty != null) {
      currentQty += widget.productCountInPackage!;
      widget.cController.text = currentQty.toString();
    }
  }

  void onTapDecrease() {
    var currentQty = int.tryParse(widget.cController.text);
    if (currentQty != null) {
      currentQty -= widget.productCountInPackage!;
      if (currentQty >= 0) {
        widget.cController.text = currentQty.toString();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        IconButton(onPressed: onTapDecrease, icon: const Icon(Icons.remove)),
        Expanded(
          child: TextFormField(
            controller: widget.cController,
            textAlign: TextAlign.center,
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
