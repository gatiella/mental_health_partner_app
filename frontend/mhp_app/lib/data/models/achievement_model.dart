import 'package:json_annotation/json_annotation.dart';
import '../../domain/entities/achievement.dart';

part 'achievement_model.g.dart';

@JsonSerializable()
class AchievementModel {
  final int id;
  final String title;
  final String description;
  final String? category;
  @JsonKey(name: 'badge_image')
  final String? badgeImage;
  final int points;

  AchievementModel({
    required this.id,
    required this.title,
    required this.description,
    this.category,
    this.badgeImage,
    required this.points,
  });

  factory AchievementModel.fromJson(Map<String, dynamic> json) {
    // Handle null values explicitly
    return AchievementModel(
      id: json['id'] as int? ?? 0,
      title: json['title'] as String? ?? '',
      description: json['description'] as String? ?? '',
      category: json['category'] as String?,
      badgeImage: json['badge_image'] as String?,
      points: json['points'] as int? ?? 0,
    );
  }

  Map<String, dynamic> toJson() => _$AchievementModelToJson(this);

  // Convert to entity
  Achievement toEntity() {
    return Achievement(
      id: id,
      title: title,
      description: description,
      category: category,
      badgeImage: badgeImage ?? 'assets/images/default_badge.png',
      points: points,
    );
  }
}

@JsonSerializable()
class UserAchievementModel {
  final int id;
  final AchievementModel achievement;
  @JsonKey(name: 'earned_at')
  final DateTime earnedAt;

  UserAchievementModel({
    required this.id,
    required this.achievement,
    required this.earnedAt,
  });

  factory UserAchievementModel.fromJson(Map<String, dynamic> json) {
    return UserAchievementModel(
      id: json['id'] as int? ?? 0,
      achievement: AchievementModel.fromJson(
          json['achievement'] as Map<String, dynamic>? ?? {}),
      earnedAt: DateTime.tryParse(json['earned_at'] as String? ?? '') ??
          DateTime.now(),
    );
  }

  Map<String, dynamic> toJson() => _$UserAchievementModelToJson(this);

  // Convert to entity
  UserAchievement toEntity() {
    return UserAchievement(
      id: id,
      achievement: achievement.toEntity(),
      earnedAt: earnedAt,
    );
  }
}
