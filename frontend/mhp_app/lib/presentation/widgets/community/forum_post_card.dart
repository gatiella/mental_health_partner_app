// lib/presentation/widgets/community/forum_post_card.dart
import 'package:flutter/material.dart';
import 'package:mental_health_partner/domain/entities/forum_post.dart';
import '../../themes/app_colors.dart';
import 'encouragement_button.dart';

class ForumPostCard extends StatelessWidget {
  final ForumPost post;
  final VoidCallback onEncouragementPressed;

  const ForumPostCard({
    super.key,
    required this.post,
    required this.onEncouragementPressed,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Author & Timestamp
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  post.authorName,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _formatTime(post.createdAt),
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),

            /// Content
            Text(
              post.content,
              style: theme.textTheme.bodyMedium?.copyWith(
                color: isDark
                    ? AppColors.textPrimaryDark
                    : AppColors.textPrimaryLight,
              ),
            ),
            const SizedBox(height: 16),

            /// Encouragement Section
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                EncouragementButton(
                  isEncouraged: post.hasEncouraged,
                  count: post.encouragementCount,
                  onPressed: onEncouragementPressed,
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}
