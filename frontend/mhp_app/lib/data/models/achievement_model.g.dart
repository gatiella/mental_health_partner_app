// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AchievementModel _$AchievementModelFromJson(Map<String, dynamic> json) =>
    AchievementModel(
      id: (json['id'] as num).toInt(),
      title: json['title'] as String,
      description: json['description'] as String,
      category: json['category'] as String?,
      badgeImage: json['badgeImage'] as String,
      points: (json['points'] as num).toInt(),
    );

Map<String, dynamic> _$AchievementModelToJson(AchievementModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'category': instance.category,
      'badgeImage': instance.badgeImage,
      'points': instance.points,
    };

UserAchievementModel _$UserAchievementModelFromJson(
        Map<String, dynamic> json) =>
    UserAchievementModel(
      id: (json['id'] as num).toInt(),
      achievement: AchievementModel.fromJson(
          json['achievement'] as Map<String, dynamic>),
      earnedAt: DateTime.parse(json['earnedAt'] as String),
    );

Map<String, dynamic> _$UserAchievementModelToJson(
        UserAchievementModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'achievement': instance.achievement,
      'earnedAt': instance.earnedAt.toIso8601String(),
    };
