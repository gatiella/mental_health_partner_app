// lib/presentation/pages/gamification/levels_page.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mental_health_partner/domain/entities/user_level.dart';
import 'package:mental_health_partner/domain/entities/user_progress.dart';
import 'package:mental_health_partner/domain/repositories/level_repository.dart';
import 'package:mental_health_partner/presentation/themes/app_colors.dart';
import 'package:mental_health_partner/presentation/widgets/gamification/level_card.dart';
import 'package:mental_health_partner/presentation/widgets/gamification/level_progress_indicator.dart';
import '../../blocs/gamification/gamification_bloc.dart';

class LevelsPage extends StatelessWidget {
  const LevelsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final isDark = theme.brightness == Brightness.dark;
    final levelRepository = LevelRepository();

    return Scaffold(
      backgroundColor:
          isDark ? AppColors.backgroundDark : AppColors.backgroundLight,
      appBar: AppBar(
        title: const Text('Levels'),
        backgroundColor:
            isDark ? AppColors.primaryDarkColor : AppColors.primaryColor,
        foregroundColor: Colors.white,
      ),
      body: BlocBuilder<GamificationBloc, GamificationState>(
        buildWhen: (prev, curr) => curr is PointsLoaded || curr is PointsError,
        builder: (context, state) {
          if (state is PointsLoaded) {
            final userProgress =
                levelRepository.getUserProgress(state.points.currentPoints);
            final allLevels = levelRepository.getAllLevels();

            return Column(
              children: [
                _buildCurrentLevelHeader(userProgress),
                Expanded(
                  child: ListView.builder(
                    padding: const EdgeInsets.all(16),
                    itemCount: allLevels.length,
                    itemBuilder: (context, index) {
                      final level = allLevels[index];
                      final isUnlocked =
                          state.points.currentPoints >= level.pointsRequired;
                      final isCurrent =
                          level.level == userProgress.currentLevel;

                      return LevelCard(
                        level: level,
                        isUnlocked: isUnlocked,
                        isCurrent: isCurrent,
                        onTap: () =>
                            _showLevelDetails(context, level, isUnlocked),
                      );
                    },
                  ),
                ),
              ],
            );
          } else if (state is PointsError) {
            return Center(child: Text('Error: ${state.message}'));
          }
          return const Center(child: CircularProgressIndicator());
        },
      ),
    );
  }

  Widget _buildCurrentLevelHeader(UserProgress progress) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            progress.currentLevelData.color.withOpacity(0.8),
            progress.currentLevelData.color
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
      ),
      child: Column(
        children: [
          Text(
            'Level ${progress.currentLevel}',
            style: const TextStyle(
              fontSize: 32,
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
          ),
          Text(
            progress.currentLevelData.title,
            style: const TextStyle(
              fontSize: 20,
              color: Colors.white70,
            ),
          ),
          const SizedBox(height: 16),
          if (progress.nextLevelData != null) ...[
            Text(
              'Progress to ${progress.nextLevelData!.title}',
              style: const TextStyle(color: Colors.white70),
            ),
            const SizedBox(height: 8),
            LevelProgressIndicator(
              progress: progress.progressPercentage,
              color: Colors.white,
            ),
            const SizedBox(height: 8),
            Text(
              '${progress.pointsToNextLevel} points to next level',
              style: const TextStyle(color: Colors.white70),
            ),
          ] else
            const Text(
              'Max Level Reached!',
              style: TextStyle(
                color: Colors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),
        ],
      ),
    );
  }

  void _showLevelDetails(
      BuildContext context, UserLevel level, bool isUnlocked) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Row(
          children: [
            Icon(
              isUnlocked ? Icons.lock_open : Icons.lock,
              color: isUnlocked ? Colors.green : Colors.grey,
            ),
            const SizedBox(width: 8),
            Text('Level ${level.level}: ${level.title}'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.asset(
              level.badgeImage,
              height: 80,
              color: isUnlocked ? null : Colors.grey,
              colorBlendMode: isUnlocked ? null : BlendMode.saturation,
            ),
            const SizedBox(height: 16),
            Text(level.description),
            const SizedBox(height: 16),
            Text(
              'Points Required: ${level.pointsRequired}',
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            const Text(
              'Perks:',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            ...level.perks.map((perk) => Padding(
                  padding: const EdgeInsets.only(left: 16, top: 4),
                  child: Text('• $perk'),
                )),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close'),
          ),
        ],
      ),
    );
  }
}
