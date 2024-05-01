import 'package:flutter/material.dart';

///General Loading View
class GeneralLoadingView extends StatelessWidget {
  ///General Loading View
  const GeneralLoadingView({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator.adaptive(),
    );
  }
}
