import 'package:flutter/material.dart';

class ModuleTextField extends StatefulWidget {
  const ModuleTextField({
    required this.controller,
    this.validator,
    this.onFieldSubmitted,
    this.keyboardType,
    this.labelText,
    this.hintText,
    this.obscureText = false,
    this.prefixIcon,
    this.errorText,
    super.key,
    this.textInputAction,
  });

  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final String? labelText;
  final String? hintText;
  final bool obscureText;
  final IconData? prefixIcon;
  final String? errorText;
  final void Function(String?)? onFieldSubmitted;

  @override
  State<ModuleTextField> createState() => _ModuleTextFieldState();
}

class _ModuleTextFieldState extends State<ModuleTextField> {
  bool _obscureText = false;
  bool _isFocused = false;

  @override
  void initState() {
    super.initState();
    _obscureText = widget.obscureText;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Theme.of(context).brightness == Brightness.dark;
    
    return Focus(
      onFocusChange: (hasFocus) {
        setState(() {
          _isFocused = hasFocus;
        });
      },
      child: TextFormField(
        decoration: InputDecoration(
          labelText: widget.labelText,
          hintText: widget.hintText,
          errorText: widget.errorText,
          prefixIcon: widget.prefixIcon != null 
            ? Icon(widget.prefixIcon,
                color: _isFocused 
                  ? Theme.of(context).primaryColor 
                  : Theme.of(context).hintColor)
            : null,
          suffixIcon: widget.obscureText
            ? IconButton(
                icon: Icon(
                  _obscureText ? Icons.visibility_off : Icons.visibility,
                  color: _isFocused 
                    ? Theme.of(context).primaryColor 
                    : Theme.of(context).hintColor,
                ),
                onPressed: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
              )
            : null,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: isDarkMode ? Colors.grey[700]! : Colors.grey[300]!,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).primaryColor,
              width: 2,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.error,
            ),
          ),
          filled: true,
          fillColor: isDarkMode 
            ? Colors.grey[900] 
            : Colors.grey[50],
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        controller: widget.controller,
        onTapOutside: (_) => FocusScope.of(context).unfocus(),
        obscureText: _obscureText,
        textInputAction: widget.textInputAction ?? TextInputAction.next,
        onFieldSubmitted: widget.onFieldSubmitted,
        keyboardType: widget.keyboardType,
        validator: widget.validator,
        style: TextStyle(
          color: isDarkMode ? Colors.white : Colors.black87,
        ),
      ),
    );
  }
}
