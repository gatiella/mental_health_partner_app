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
            curr is EarnedAchievementsLoading,
        builder: (context, state) {
          if (state is EarnedAchievementsLoading) {
            return const Center(child: CircularProgressIndicator());
          }
          if (state is EarnedAchievementsLoaded) {
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
            Image.asset(achievement.achievement.badgeImage, height: 100),
            const SizedBox(height: 16),
            Text(achievement.achievement.description),
            const SizedBox(height: 16),
            Text('Earned: ${achievement.earnedAt.toString().split(' ')[0]}'),
          ],
        ),
      ),
    );
  }
}
