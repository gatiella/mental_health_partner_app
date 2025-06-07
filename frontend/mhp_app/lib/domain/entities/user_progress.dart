// lib/domain/entities/user_progress.dart
import 'package:mental_health_partner/domain/entities/user_level.dart';

class UserProgress {
  final int currentLevel;
  final int currentPoints;
  final int pointsToNextLevel;
  final UserLevel currentLevelData;
  final UserLevel? nextLevelData;
  final double progressPercentage;

  const UserProgress({
    required this.currentLevel,
    required this.currentPoints,
    required this.pointsToNextLevel,
    required this.currentLevelData,
    this.nextLevelData,
    required this.progressPercentage,
  });
}
