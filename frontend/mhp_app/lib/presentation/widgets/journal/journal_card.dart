import 'package:flutter/material.dart';
import 'package:mental_health_partner/presentation/themes/app_colors.dart';
import '../../../../domain/entities/journal.dart';

class JournalCard extends StatelessWidget {
  final Journal entry;
  final VoidCallback onDelete;

  const JournalCard({
    super.key,
    required this.entry,
    required this.onDelete,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    final surfaceColor =
        isDark ? AppColors.surfaceDark : AppColors.surfaceLight;

    final primaryTextColor =
        isDark ? AppColors.textPrimaryDark : AppColors.textPrimaryLight;

    final secondaryTextColor =
        isDark ? AppColors.textSecondaryDark : AppColors.textSecondaryLight;

    return Card(
      color: surfaceColor,
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Title & Delete Button
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Flexible(
                  child: Text(
                    entry.title,
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: primaryTextColor,
                      fontWeight: FontWeight.w600,
                    ),
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                IconButton(
                  icon: const Icon(Icons.delete_outline),
                  color: AppColors.errorColor,
                  tooltip: 'Delete entry',
                  onPressed: onDelete,
                ),
              ],
            ),

            const SizedBox(height: 8),

            /// Content
            Text(
              entry.content,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: secondaryTextColor,
              ),
              maxLines: 4,
              overflow: TextOverflow.ellipsis,
            ),

            const SizedBox(height: 12),

            /// Mood Tag
            Align(
              alignment: Alignment.centerLeft,
              child: Chip(
                backgroundColor: _getMoodColor(entry.moodScore),
                label: Text(
                  entry.moodNote ?? 'No mood note',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.onPrimary,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              ),
            ),

            const SizedBox(height: 4),

            /// Timestamp
            Align(
              alignment: Alignment.centerRight,
              child: Text(
                _formatDate(entry.createdAt),
                style: theme.textTheme.bodySmall?.copyWith(
                  color: secondaryTextColor,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Color _getMoodColor(int? moodScore) {
    switch (moodScore) {
      case 1:
        return AppColors.moodSad;
      case 2:
        return AppColors.moodNeutral;
      case 3:
        return AppColors.moodHappy;
      case 4:
        return AppColors.moodCalm;
      case 5:
        return AppColors.successLightColor;
      default:
        return AppColors.secondaryLightColor.withOpacity(0.4);
    }
  }

  String _formatDate(DateTime date) {
    return "${date.day}/${date.month}/${date.year}";
  }
}
