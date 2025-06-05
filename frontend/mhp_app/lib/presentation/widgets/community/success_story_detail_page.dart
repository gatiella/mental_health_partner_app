import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_partner/domain/entities/success_story.dart';
import 'package:mental_health_partner/presentation/blocs/community/community_bloc.dart';
import 'package:mental_health_partner/presentation/blocs/community/community_event.dart';
import '../../themes/app_colors.dart';
import 'encouragement_button.dart';

class SuccessStoryDetailPage extends StatelessWidget {
  final SuccessStory story;

  const SuccessStoryDetailPage({
    super.key,
    required this.story,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Text(story.title),
        elevation: 2,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Card(
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          color: isDark ? AppColors.surfaceDark : AppColors.surfaceLight,
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  story.title,
                  style: theme.textTheme.headlineSmall?.copyWith(
                    color: isDark
                        ? AppColors.textPrimaryDark
                        : AppColors.textPrimaryLight,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 16),
                Text(
                  story.content,
                  style: theme.textTheme.bodyLarge?.copyWith(
                    color: isDark
                        ? AppColors.textSecondaryDark
                        : AppColors.textSecondaryLight,
                    height: 1.6,
                  ),
                ),
                const SizedBox(height: 20),
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
                const SizedBox(height: 16),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '${story.encouragementCount} encouragements',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: isDark
                            ? AppColors.textSecondaryDark
                            : AppColors.textSecondaryLight,
                      ),
                    ),
                    EncouragementButton(
                      isEncouraged: story.hasEncouraged,
                      count: story.encouragementCount,
                      onPressed: () {
                        context.read<CommunityBloc>().add(
                              ToggleStoryEncouragement(storyId: story.id),
                            );
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
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
