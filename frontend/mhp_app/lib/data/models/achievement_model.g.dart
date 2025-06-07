// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'achievement_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Map<String, dynamic> _$AchievementModelToJson(AchievementModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'title': instance.title,
      'description': instance.description,
      'category': instance.category,
      'badge_image': instance.badgeImage,
      'points': instance.points,
    };

Map<String, dynamic> _$UserAchievementModelToJson(
        UserAchievementModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'achievement': instance.achievement,
      'earned_at': instance.earnedAt.toIso8601String(),
    };
