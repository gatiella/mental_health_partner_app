// lib/presentation/pages/gamification/achievements_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_partner/domain/entities/achievement.dart';
import '../../blocs/gamification/gamification_bloc.dart';
import '../../widgets/gamification/achievement_badge.dart';

class AchievementsPage extends StatelessWidget {
  const AchievementsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Achievements')),
      body: BlocBuilder<GamificationBloc, GamificationState>(
        buildWhen: (prev, curr) =>
            curr is EarnedAchievementsLoaded ||
            curr is EarnedAchievementsLoading ||
            curr is EarnedAchievementsError,
        builder: (context, state) {
          // Trigger loading earned achievements when page loads
          if (state is! EarnedAchievementsLoaded &&
              state is! EarnedAchievementsLoading &&
              state is! EarnedAchievementsError) {
            context.read<GamificationBloc>().add(LoadEarnedAchievements());
            return const Center(child: CircularProgressIndicator());
          }

          if (state is EarnedAchievementsLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is EarnedAchievementsError) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text('Error: ${state.message}'),
                  ElevatedButton(
                    onPressed: () {
                      context
                          .read<GamificationBloc>()
                          .add(LoadEarnedAchievements());
                    },
                    child: const Text('Retry'),
                  ),
                ],
              ),
            );
          }

          if (state is EarnedAchievementsLoaded) {
            if (state.achievements.isEmpty) {
              return const Center(child: Text('No achievements earned yet'));
            }

            return GridView.builder(
              padding: const EdgeInsets.all(16),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 16,
                mainAxisSpacing: 16,
                childAspectRatio: 0.8,
              ),
              itemCount: state.achievements.length,
              itemBuilder: (context, index) {
                final achievement = state.achievements[index];
                return AchievementBadge(
                  achievement: achievement.achievement,
                  earned: true,
                  onTap: () => _showAchievementDetails(context, achievement),
                );
              },
            );
          }

          return const Center(child: Text('No achievements earned yet'));
        },
      ),
    );
  }

  void _showAchievementDetails(
      BuildContext context, UserAchievement achievement) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(achievement.achievement.title),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            _buildDialogImage(achievement.achievement.badgeImage),
            const SizedBox(height: 16),
            Text(achievement.achievement.description),
            const SizedBox(height: 16),
            Text('Earned: ${achievement.earnedAt.toString().split(' ')[0]}'),
            const SizedBox(height: 8),
            Text('Points: ${achievement.achievement.points}'),
          ],
        ),
      ),
    );
  }

  Widget _buildDialogImage(String imageUrl) {
    if (imageUrl.startsWith('http://') || imageUrl.startsWith('https://')) {
      return Image.network(
        imageUrl,
        height: 100,
        errorBuilder: (context, error, stackTrace) {
          return Container(
            height: 100,
            width: 100,
            decoration: BoxDecoration(
              color: Colors.grey.shade300,
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(
              Icons.emoji_events,
              color: Colors.grey,
              size: 50,
            ),
          );
        },
      );
    } else {
      return Image.asset(imageUrl, height: 100);
    }
  }
}
