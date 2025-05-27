// lib/presentation/widgets/community/forum_thread_card.dart
import 'package:flutter/material.dart';
import 'package:mental_health_partner/domain/entities/forum_thread.dart';
import '../../themes/app_colors.dart';

class ForumThreadCard extends StatelessWidget {
  final ForumThread thread;
  final VoidCallback onTap;

  const ForumThreadCard({
    super.key,
    required this.thread,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Card(
      elevation: 2,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Expanded(
                    child: Text(
                      thread.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  if (thread.isPinned)
                    const Icon(Icons.push_pin,
                        size: 16, color: AppColors.primaryColor),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                children: [
                  _buildDetailChip(
                    context,
                    icon: Icons.message,
                    label: '${thread.postCount} posts',
                  ),
                  const SizedBox(width: 8),
                  _buildDetailChip(
                    context,
                    icon: Icons.schedule,
                    label: _timeSinceLastPost(thread.lastPostAt),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                'Started by ${thread.authorName}',
                style: theme.textTheme.bodySmall?.copyWith(
                  color: isDark
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

  Widget _buildDetailChip(BuildContext context,
      {required IconData icon, required String label}) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(label),
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
      labelStyle: Theme.of(context).textTheme.bodySmall,
    );
  }

  String _timeSinceLastPost(DateTime date) {
    final difference = DateTime.now().difference(date);
    if (difference.inDays > 0) return '${difference.inDays}d ago';
    if (difference.inHours > 0) return '${difference.inHours}h ago';
    return '${difference.inMinutes}m ago';
  }
}
