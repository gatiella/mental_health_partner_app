import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_partner/domain/entities/success_story.dart';
import 'package:mental_health_partner/presentation/blocs/community/community_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/community/community_event.dart';
import '../../themes/app_colors.dart';
import 'encouragement_button.dart';
import 'success_story_detail_page.dart';

class SuccessStoryCard extends StatelessWidget {
  final SuccessStory story;

  const SuccessStoryCard({
    super.key,
    required this.story,
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
        onTap: () => _navigateToStoryDetail(context),
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
                      story.title,
                      style: theme.textTheme.titleMedium?.copyWith(
                        color: isDark
                            ? AppColors.textPrimaryDark
                            : AppColors.textPrimaryLight,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  EncouragementButton(
                    isEncouraged: story.hasEncouraged,
                    count: story.encouragementCount,
                    onPressed: () => context.read<CommunityBloc>().add(
                          ToggleStoryEncouragement(storyId: story.id),
                        ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Text(
                story.content,
                style: theme.textTheme.bodyMedium?.copyWith(
                  color: isDark
                      ? AppColors.textSecondaryDark
                      : AppColors.textSecondaryLight,
                ),
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Chip(
                    label: Text(story.category),
                    backgroundColor: _getCategoryColor(story.category),
                  ),
                  const Spacer(),
                  Text(
                    _formatDate(story.createdAt),
                    style: theme.textTheme.bodySmall?.copyWith(
                      color: isDark
                          ? AppColors.textSecondaryDark
                          : AppColors.textSecondaryLight,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _navigateToStoryDetail(BuildContext context) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => SuccessStoryDetailPage(story: story),
      ),
    );
  }

  Color _getCategoryColor(String category) {
    switch (category.toLowerCase()) {
      case 'anxiety':
        return AppColors.moodCalm.withOpacity(0.2);
      case 'depression':
        return AppColors.moodSad.withOpacity(0.2);
      case 'recovery':
        return AppColors.successLightColor.withOpacity(0.2);
      default:
        return AppColors.secondaryLightColor.withOpacity(0.2);
    }
  }

  String _formatDate(DateTime date) {
    return '${date.day}/${date.month}/${date.year}';
  }
}
