// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_streak_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserStreakModel _$UserStreakModelFromJson(Map<String, dynamic> json) =>
    UserStreakModel(
      currentStreak: (json['currentStreak'] as num).toInt(),
      longestStreak: (json['longestStreak'] as num).toInt(),
      lastCompletionDate: const SafeDateTimeConverter()
          .fromJson(json['lastCompletionDate'] as String?),
      completedToday: json['completedToday'] as bool,
      daysUntilNextLevel: (json['daysUntilNextLevel'] as num).toInt(),
      nextLevelName: json['nextLevelName'] as String,
    );

Map<String, dynamic> _$UserStreakModelToJson(UserStreakModel instance) =>
    <String, dynamic>{
      'currentStreak': instance.currentStreak,
      'longestStreak': instance.longestStreak,
      'completedToday': instance.completedToday,
      'daysUntilNextLevel': instance.daysUntilNextLevel,
      'nextLevelName': instance.nextLevelName,
      'lastCompletionDate':
          const SafeDateTimeConverter().toJson(instance.lastCompletionDate),
    };
