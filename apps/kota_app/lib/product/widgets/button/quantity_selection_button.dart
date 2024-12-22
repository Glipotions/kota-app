import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class QuantitySelectionButton extends StatefulWidget {
  const QuantitySelectionButton({
    required this.cController,
    this.productCountInPackage = 1,
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
      final currentQty = int.tryParse(text);
      if (currentQty != null) {
        final roundedQty = (currentQty ~/ (widget.productCountInPackage ?? 1)) *
            (widget.productCountInPackage ?? 1);
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
      currentQty += widget.productCountInPackage ?? 1;
      widget.cController.text = currentQty.toString();
    }
  }

  void onTapDecrease() {
    var currentQty = int.tryParse(widget.cController.text);
    if (currentQty != null) {
      currentQty -= widget.productCountInPackage ?? 1;
      if (currentQty >= 0) {
        widget.cController.text = currentQty.toString();
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Theme.of(context).dividerColor),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          IconButton(
            onPressed: onTapDecrease,
            icon: const Icon(Icons.remove),
            padding: const EdgeInsets.all(8),
          ),
          Expanded(
            child: TextFormField(
              controller: widget.cController,
              textAlign: TextAlign.center,
              keyboardType: TextInputType.number,
              onTap: () {
                widget.cController.selection = TextSelection(
                  baseOffset: 0,
                  extentOffset: widget.cController.text.length,
                );
              },
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                contentPadding: EdgeInsets.zero,
              ),
              inputFormatters: <TextInputFormatter>[
                FilteringTextInputFormatter.digitsOnly,
              ],
            ),
          ),
          IconButton(
            onPressed: onTapIncrease,
            icon: const Icon(Icons.add),
            padding: const EdgeInsets.all(8),
          ),
        ],
      ),
    );
  }
}
