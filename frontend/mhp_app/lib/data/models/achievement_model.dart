import 'package:json_annotation/json_annotation.dart';

part 'achievement_model.g.dart';

@JsonSerializable()
class AchievementModel {
  final int id;
  final String title;
  final String description;
  final String? category;
  final String badgeImage;
  final int points;

  AchievementModel({
    required this.id,
    required this.title,
    required this.description,
    this.category,
    required this.badgeImage,
    required this.points,
  });

  factory AchievementModel.fromJson(Map<String, dynamic> json) =>
      _$AchievementModelFromJson(json);
  Map<String, dynamic> toJson() => _$AchievementModelToJson(this);
}

@JsonSerializable()
class UserAchievementModel {
  final int id;
  final AchievementModel achievement;
  final DateTime earnedAt;

  UserAchievementModel({
    required this.id,
    required this.achievement,
    required this.earnedAt,
  });

  factory UserAchievementModel.fromJson(Map<String, dynamic> json) =>
      _$UserAchievementModelFromJson(json);
  Map<String, dynamic> toJson() => _$UserAchievementModelToJson(this);
}
