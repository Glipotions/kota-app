import 'package:flutter/material.dart';

class ModernCartButton extends StatelessWidget {
  const ModernCartButton({
    required this.text,
    required this.onTap,
    this.icon,
    this.width,
    this.height = 48.0,
    this.isEnabled = true,
    super.key,
  });

  final String text;
  final VoidCallback onTap;
  final IconData? icon;
  final double? width;
  final double height;
  final bool isEnabled;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isUpdate = text == 'Sepeti Güncelle';
    
    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: isEnabled ? onTap : null,
        borderRadius: BorderRadius.circular(12),
        child: Ink(
          width: width ?? double.infinity,
          height: height,
          decoration: BoxDecoration(
            gradient: isEnabled
              ? LinearGradient(
                  colors: isUpdate ? [
                    Colors.orange.shade700,
                    Colors.orange.shade500,
                  ] : [
                    theme.colorScheme.primary,
                    theme.colorScheme.primaryContainer,
                  ],
                )
              : LinearGradient(
                  colors: [
                    Colors.grey.shade300,
                    Colors.grey.shade400,
                  ],
                ),
            borderRadius: BorderRadius.circular(12),
            boxShadow: [
              BoxShadow(
                color: (isUpdate ? Colors.orange : theme.colorScheme.primary).withOpacity(0.3),
                blurRadius: 8,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              if (icon != null) ...[
                Icon(
                  icon,
                  color: theme.colorScheme.onPrimary,
                  size: 20,
                ),
                const SizedBox(width: 8),
              ],
              Text(
                text,
                style: theme.textTheme.titleMedium?.copyWith(
                  color: theme.colorScheme.onPrimary,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
