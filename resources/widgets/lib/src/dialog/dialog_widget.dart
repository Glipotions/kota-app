import 'package:flutter/material.dart';

// ignore: public_member_api_docs
abstract class DialogWidget<T> extends StatelessWidget {
  // ignore: public_member_api_docs
  const DialogWidget({
    super.key,
  });

  // ignore: public_member_api_docs
  Future<T?> show({
    required BuildContext context,
    bool? barrierDismissible,
    Color? barrierColor,
  }) async {
    return showDialog<T>(
      barrierDismissible: barrierDismissible ?? true,
      barrierColor: barrierColor ?? Colors.black45,
      context: context,
      builder: (BuildContext context) {
        return _AnimatedDialog(
          child: this,
        );
      },
    );
  }
}

class _AnimatedDialog<T> extends StatefulWidget {
  const _AnimatedDialog({
    required this.child, super.key,
  });

  final DialogWidget<T> child;

  @override
  _AnimatedDialogState<T> createState() => _AnimatedDialogState<T>();
}

class _AnimatedDialogState<T> extends State<_AnimatedDialog<T>>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Offset> _animation;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _animation = Tween<Offset>(
      begin: const Offset(0, -1),
      end: Offset.zero,
    ).animate(_controller);
    _controller.forward();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: Dialog(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: widget.child,
        ),
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }
}
