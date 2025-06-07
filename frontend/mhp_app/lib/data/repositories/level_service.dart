// Service class to handle level-related operations
import 'package:flutter/material.dart';
import 'package:mental_health_partner/domain/entities/user_level.dart';
import 'package:mental_health_partner/domain/entities/user_progress.dart';
import 'package:mental_health_partner/domain/repositories/level_repository.dart';
import 'package:mental_health_partner/presentation/blocs/gamification/gamification_bloc.dart';
import 'package:mental_health_partner/presentation/widgets/gamification/level_unlock_dialog.dart';

class LevelService {
  final LevelRepository _levelRepository;

  LevelService({
    required LevelRepository levelRepository,
    required GamificationBloc gamificationBloc,
  }) : _levelRepository = levelRepository;

  void checkAndShowLevelUp(BuildContext context, int oldPoints, int newPoints) {
    final oldLevel = _levelRepository.getLevelByPoints(oldPoints);
    final newLevel = _levelRepository.getLevelByPoints(newPoints);

    if (newLevel.level > oldLevel.level) {
      // Show level up dialog
      WidgetsBinding.instance.addPostFrameCallback((_) {
        LevelUnlockDialog.show(context, newLevel);
      });
    }
  }

  UserProgress getUserProgress(int points) {
    return _levelRepository.getUserProgress(points);
  }

  List<UserLevel> getAllLevels() {
    return _levelRepository.getAllLevels();
  }

  bool canAccessFeature(int userPoints, String feature) {
    final currentLevel = _levelRepository.getLevelByPoints(userPoints);

    // Define feature requirements by level
    switch (feature) {
      case 'mood_tracking':
        return currentLevel.level >= 2;
      case 'advanced_exercises':
        return currentLevel.level >= 3;
      case 'custom_goals':
        return currentLevel.level >= 3;
      case 'premium_content':
        return currentLevel.level >= 4;
      case 'one_on_one_sessions':
        return currentLevel.level >= 4;
      case 'community_access':
        return currentLevel.level >= 4;
      case 'mentor_badge':
        return currentLevel.level >= 6;
      default:
        return true; // Basic features available to all
    }
  }
}
