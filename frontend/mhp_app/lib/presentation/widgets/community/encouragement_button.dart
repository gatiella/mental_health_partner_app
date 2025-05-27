// lib/presentation/widgets/community/encouragement_button.dart
import 'package:flutter/material.dart';
import '../../themes/app_colors.dart';

class EncouragementButton extends StatelessWidget {
  final bool isEncouraged;
  final int count;
  final VoidCallback onPressed;

  const EncouragementButton({
    super.key,
    required this.isEncouraged,
    required this.count,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Material(
      borderRadius: BorderRadius.circular(20),
      elevation: 1,
      child: InkWell(
        borderRadius: BorderRadius.circular(20),
        onTap: onPressed,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
          decoration: BoxDecoration(
            color: isEncouraged
                ? AppColors.successColor.withOpacity(0.1)
                : isDark
                    ? AppColors.surfaceDark
                    : AppColors.surfaceLight,
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: isEncouraged
                  ? AppColors.successColor
                  : AppColors.textSecondaryLight,
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.favorite,
                size: 16,
                color: isEncouraged
                    ? AppColors.successColor
                    : AppColors.textSecondaryLight,
              ),
              const SizedBox(width: 4),
              Text(
                count.toString(),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isEncouraged
                      ? AppColors.successColor
                      : isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
