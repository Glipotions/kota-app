import 'package:flutter/material.dart';

class ModuleTextField extends StatelessWidget {
  const ModuleTextField({
    required this.controller,
    this.validator,
    this.onFieldSubmitted,
    this.keyboardType,
    this.labelText,
    this.obscureText=false,
    super.key,
  });

  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final String? labelText;
  final bool obscureText;
  final void Function(String?)? onFieldSubmitted;
  
  

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: labelText,
      ),
      controller: controller,
      obscureText: obscureText,
      onFieldSubmitted: onFieldSubmitted,
      keyboardType: keyboardType,
      validator: validator,
    );
  }
}
