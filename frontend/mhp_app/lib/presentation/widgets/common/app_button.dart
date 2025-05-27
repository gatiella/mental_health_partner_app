import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';

enum ButtonType { primary, secondary, outline }

class AppButton extends StatelessWidget {
  final String text;
  final VoidCallback? onPressed;
  final ButtonType type;
  final bool isLoading;
  final double? width;
  final Widget? icon;
  final Gradient? gradient;
  final double elevation;
  final EdgeInsetsGeometry? padding;

  const AppButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = ButtonType.primary,
    this.isLoading = false,
    this.width,
    this.icon,
    this.gradient,
    this.elevation = 2,
    this.padding,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return SizedBox(
      width: width,
      child: Material(
        elevation: elevation,
        borderRadius: BorderRadius.circular(12),
        child: InkWell(
          onTap: isLoading ? null : onPressed,
          borderRadius: BorderRadius.circular(12),
          child: Container(
            padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
            decoration: BoxDecoration(
              gradient: _getBackgroundGradient(theme, isDark),
              borderRadius: BorderRadius.circular(12),
              border: type == ButtonType.outline
                  ? Border.all(color: AppColors.primaryColor)
                  : null,
            ),
            child: _buildButtonContent(theme),
          ),
        ),
      ),
    );
  }

  Gradient? _getBackgroundGradient(ThemeData theme, bool isDark) {
    if (gradient != null) return gradient;
    if (type == ButtonType.primary) {
      return const LinearGradient(
        colors: [
          AppColors.primaryColor,
          AppColors.primaryDarkColor,
        ],
        begin: Alignment.topLeft,
        end: Alignment.bottomRight,
      );
    }
    return null;
  }

  Widget _buildButtonContent(ThemeData theme) {
    final textColor = type == ButtonType.primary || gradient != null
        ? Colors.white
        : AppColors.primaryColor;

    if (isLoading) {
      return Center(
        child: CircularProgressIndicator(
          strokeWidth: 2,
          valueColor: AlwaysStoppedAnimation<Color>(textColor),
        ),
      );
    }

    return Row(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        if (icon != null) ...[
          IconTheme(
            data: IconThemeData(color: textColor, size: 20),
            child: icon!,
          ),
          const SizedBox(width: 12),
        ],
        Text(
          text,
          style: theme.textTheme.labelLarge?.copyWith(
            color: textColor,
            fontWeight: FontWeight.w600,
            letterSpacing: 0.5,
          ),
        ),
      ],
    );
  }
}
