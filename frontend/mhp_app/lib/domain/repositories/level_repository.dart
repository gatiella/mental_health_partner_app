// lib/data/repositories/level_repository.dart
import 'package:mental_health_partner/domain/entities/user_progress.dart';
import 'package:mental_health_partner/presentation/themes/app_colors.dart';
import '../../domain/entities/user_level.dart';

class LevelRepository {
  static final List<UserLevel> _levels = [
    const UserLevel(
      level: 1,
      title: "Beginner",
      description: "Welcome to your mental health journey!",
      pointsRequired: 0,
      badgeImage: "assets/badges/beginner.png",
      perks: ["Access to basic content", "Daily check-ins"],
      color: AppColors.moodNeutral,
    ),
    const UserLevel(
      level: 2,
      title: "Explorer",
      description: "You're getting started!",
      pointsRequired: 100,
      badgeImage: "assets/badges/explorer.png",
      perks: ["Mood tracking", "Basic exercises", "Weekly insights"],
      color: AppColors.moodCalm,
    ),
    const UserLevel(
      level: 3,
      title: "Practitioner",
      description: "Building healthy habits!",
      pointsRequired: 300,
      badgeImage: "assets/badges/practitioner.png",
      perks: ["Advanced exercises", "Custom goals", "Progress analytics"],
      color: AppColors.secondaryColor,
    ),
    const UserLevel(
      level: 4,
      title: "Champion",
      description: "You're doing great!",
      pointsRequired: 600,
      badgeImage: "assets/badges/champion.png",
      perks: ["Premium content", "1-on-1 sessions", "Community access"],
      color: AppColors.meditationAccent,
    ),
    const UserLevel(
      level: 5,
      title: "Master",
      description: "Mental health master!",
      pointsRequired: 1000,
      badgeImage: "assets/badges/master.png",
      perks: ["All features", "Priority support", "Exclusive workshops"],
      color: AppColors.successColor,
    ),
    const UserLevel(
      level: 6,
      title: "Legend",
      description: "Inspiring others on their journey!",
      pointsRequired: 1500,
      badgeImage: "assets/badges/legend.png",
      perks: ["Mentor badge", "Community leader", "Beta features"],
      color: AppColors.primaryColor,
    ),
  ];

  List<UserLevel> getAllLevels() => _levels;

  UserLevel getLevelByPoints(int points) {
    for (int i = _levels.length - 1; i >= 0; i--) {
      if (points >= _levels[i].pointsRequired) {
        return _levels[i];
      }
    }
    return _levels.first;
  }

  UserLevel? getNextLevel(int currentLevel) {
    if (currentLevel < _levels.length) {
      return _levels[currentLevel]; // Next level (0-indexed)
    }
    return null;
  }

  UserProgress getUserProgress(int points) {
    final currentLevel = getLevelByPoints(points);
    final nextLevel = getNextLevel(currentLevel.level);

    int pointsToNext = 0;
    double progressPercentage = 1.0;

    if (nextLevel != null) {
      pointsToNext = nextLevel.pointsRequired - points;
      final pointsInCurrentLevel = points - currentLevel.pointsRequired;
      final pointsNeededForLevel =
          nextLevel.pointsRequired - currentLevel.pointsRequired;
      progressPercentage = pointsInCurrentLevel / pointsNeededForLevel;
    }

    return UserProgress(
      currentLevel: currentLevel.level,
      currentPoints: points,
      pointsToNextLevel: pointsToNext,
      currentLevelData: currentLevel,
      nextLevelData: nextLevel,
      progressPercentage: progressPercentage,
    );
  }
}
