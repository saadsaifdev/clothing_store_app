import 'package:flutter/material.dart';
class CustomButton extends StatelessWidget {
  const CustomButton({
    super.key,
    required this.onTap,
    required this.text,
    this.backgroundColor, 
  });

  final String text;
  final VoidCallback? onTap;
  final Color? backgroundColor;

  bool get _isEnabled => onTap != null;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    final defaultBlue = Colors.blue;
    final activeColor = backgroundColor ?? defaultBlue;

    return Semantics(
      button: true,
      enabled: _isEnabled,
      label: text,
      child: SizedBox(
        width: double.infinity,
        height: 60,
        child: Material(
          color: _isEnabled
              ? activeColor
              : colorScheme.onSurface.withValues(alpha: 0.12),
          borderRadius: BorderRadius.circular(8),
          clipBehavior: Clip.antiAlias,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(8),
            splashColor: Colors.white.withValues(alpha: 0.2),
            highlightColor: Colors.white.withValues(alpha: 0.1),
            child: Center(
              child: Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16),
                child: Text(
                  text,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  textAlign: TextAlign.center,
                  style: theme.textTheme.titleMedium?.copyWith(
                    color: _isEnabled
                        ? Colors.white
                        : colorScheme.onSurface.withValues(alpha: 0.38),
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}