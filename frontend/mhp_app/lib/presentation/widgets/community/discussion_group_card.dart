// lib/presentation/widgets/community/discussion_group_card.dart

import 'package:flutter/material.dart';
import 'package:mental_health_partner/domain/entities/discussion_group.dart';
import '../../themes/app_colors.dart';

class DiscussionGroupCard extends StatelessWidget {
  final DiscussionGroup group;
  final VoidCallback onJoin;
  final VoidCallback? onTap;

  const DiscussionGroupCard({
    super.key,
    required this.group,
    required this.onJoin,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return GestureDetector(
      onTap: onTap,
      child: Card(
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
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
                      group.name,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                      ),
                    ),
                  ),
                  IconButton(
                    icon: Icon(
                      group.isMember ? Icons.group_remove : Icons.group_add,
                      color: group.isMember
                          ? AppColors.errorColor
                          : AppColors.primaryColor,
                    ),
                    onPressed: onJoin,
                  ),
                ],
              ),
              Text(
                group.description,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  _buildCountChip(context, Icons.people, group.memberCount),
                  const SizedBox(width: 8),
                  _buildCountChip(context, Icons.forum, group.threadCount),
                  const Spacer(),
                  Chip(
                    label: Text(group.topicType),
                    backgroundColor: _getTopicColor(group.topicType),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildCountChip(BuildContext context, IconData icon, int count) {
    return Chip(
      avatar: Icon(icon, size: 16),
      label: Text(count.toString()),
      backgroundColor: Theme.of(context).colorScheme.secondaryContainer,
    );
  }

  Color _getTopicColor(String topic) {
    switch (topic.toLowerCase()) {
      case 'anxiety':
        return AppColors.moodCalm.withOpacity(0.2);
      case 'depression':
        return AppColors.moodSad.withOpacity(0.2);
      case 'stress':
        return AppColors.moodAnxious.withOpacity(0.2);
      default:
        return AppColors.secondaryLightColor.withOpacity(0.2);
    }
  }
}
