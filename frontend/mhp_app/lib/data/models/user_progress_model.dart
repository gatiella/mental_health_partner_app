// lib/data/models/user_progress_model.dart
import 'package:mental_health_partner/domain/entities/user_progress.dart';
import 'package:mental_health_partner/data/models/user_level_model.dart';

class UserProgressModel extends UserProgress {
  const UserProgressModel({
    required super.currentLevel,
    required super.currentPoints,
    required super.pointsToNextLevel,
    required super.currentLevelData,
    super.nextLevelData,
    required super.progressPercentage,
  });

  factory UserProgressModel.fromJson(Map<String, dynamic> json) {
    return UserProgressModel(
      currentLevel: json['currentLevel'] ?? 1,
      currentPoints: json['currentPoints'] ?? 0,
      pointsToNextLevel: json['pointsToNextLevel'] ?? 0,
      currentLevelData: UserLevelModel.fromJson(json['currentLevelData'] ?? {}),
      nextLevelData: json['nextLevelData'] != null
          ? UserLevelModel.fromJson(json['nextLevelData'])
          : null,
      progressPercentage: (json['progressPercentage'] ?? 0.0).toDouble(),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'currentLevel': currentLevel,
      'currentPoints': currentPoints,
      'pointsToNextLevel': pointsToNextLevel,
      'currentLevelData': (currentLevelData as UserLevelModel).toJson(),
      'nextLevelData': nextLevelData != null
          ? (nextLevelData! as UserLevelModel).toJson()
          : null,
      'progressPercentage': progressPercentage,
    };
  }

  UserProgress toEntity() {
    return UserProgress(
      currentLevel: currentLevel,
      currentPoints: currentPoints,
      pointsToNextLevel: pointsToNextLevel,
      currentLevelData: currentLevelData,
      nextLevelData: nextLevelData,
      progressPercentage: progressPercentage,
    );
  }
}
